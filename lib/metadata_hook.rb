class CrystalMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'crystal',
        icon: {type: 'devicon', name: 'ruby'},
        version: '1.0',
        extension: 'cr',
        ace_mode: 'crystal'
    },
     test_framework: {
         name: 'crystal',
         version: '2.13',
         test_extension: 'cr'
     }}
  end
end
