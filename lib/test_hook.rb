class CrystalTestHook < Mumukit::Templates::FileHook
  isolated true
  structured true

  def compile_file_content(req)
<<CRYSTAL
require "spec"
require "json"
module Spec
  # :nodoc:
  class JSONFormatter < Formatter
    @output : IO
    @results = [] of Spec::Result

    def initialize(@output)
    end

    def report(result)
      @results << result
    end

    def finish
      @output.write({"examples" => @results.map { |r| write_report(r) }}.to_json.to_slice)
    end

    private def write_report(result)
      attributes = {
        status:      map_status(result.kind),
        exception:   { message: result.exception.try(&.message)},
        full_description:      result.description,
      }
    end

    private def map_status(status)
      if status == :fail || status == :error
        "\#\{status\}ed"
      else
        "passed"
      end
    end
  end
end
Spec.override_default_formatter(Spec::JSONFormatter.new(STDOUT))
#{req.extra}
#{req.content}
describe "tests" do
  #{req.test}
end
CRYSTAL
  end

  def tempfile_extension
    '.cr'
  end

  def command_line(filename)
    "crystal spec ../..#{filename}"
  end

  def to_structured_result(result)
    result = result.split("\n").first
    transform(super['examples'])
  end

  def transform(examples)
    examples.map { |e| [e['full_description'].strip, e['status'].to_sym, parse_out(e['exception'])] }
  end

  def parse_out(exception)
    exception['message'] || ''
  end
end
