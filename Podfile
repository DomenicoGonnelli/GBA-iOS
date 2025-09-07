platform :ios, '14.0'
inhibit_all_warnings!

# ---- PODS CONDIVISI TRA GemBoy e GemBoyNew ----
abstract_target 'GemBoyShared' do
  use_modular_headers!

  pod 'SQLite.swift', '~> 0.12.0'
  pod 'SDWebImage', '~> 3.8'
  pod 'SMCalloutView', '~> 2.1.0'
  # pod 'GoogleSignIn'
  pod 'lottie-ios'
  pod 'Alamofire'
  pod 'Kingfisher','~> 5.15.7'
  pod 'CircleBar', :git => 'https://github.com/DomenicoGonnelli/CircleBar.git', :branch => 'General'
  pod 'CollectionViewPagingLayout'
  pod 'ReachabilitySwift'

  # Cores locali
  pod 'GameCore',       :path => 'Cores/GameCore'
  pod 'NESGameCore',    :path => 'Cores/NESGameCore'
  pod 'SNESGameCore',   :path => 'Cores/SNESGameCore'
  pod 'N64GameCore',    :path => 'Cores/N64GameCore'
  pod 'GBAGameCore',    :path => 'Cores/GBAGameCore'
  pod 'MelonDSGameCore',:path => 'Cores/MelonDSGameCore'

  pod 'Roxas', :path => 'External/Roxas'

  # I due target che devono essere identici
  target 'GemBoy' do
  end

  target 'Darlion' do
  end
end

# ---- TARGET DI PREVIEW (non eredita i pods condivisi) ----
target 'GemBoyPreviews' do
  use_modular_headers!
  pod 'GameCore', :path => 'Cores/GameCore'
  pod 'Roxas',     :path => 'External/Roxas'
end

# ---- POST INSTALL: rimuove -l"DeltaCore" dagli OTHER_LDFLAGS per evitare conflitti con Systems.framework ----
post_install do |installer|
  targets_to_patch = ["Pods-GemBoy", "Pods-Darlion"]

  installer.pods_project.targets.each do |t|
    next unless targets_to_patch.include?(t.name)

    puts "Patching OTHER_LDFLAGS for #{t.name}"
    t.build_configurations.each do |config|
      # Se esiste un file xcconfig, operiamo lì
      if config.base_configuration_reference && config.base_configuration_reference.real_path
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        # rimuove ogni occorrenza di -l"DeltaCore"
        new_xcconfig = xcconfig.gsub(/\s*-l"GameCore"\b/, '')
        File.open(xcconfig_path, "w") { |f| f << new_xcconfig }
      else
        # Fallback: operiamo direttamente su OTHER_LDFLAGS in memoria
        flags = config.build_settings['OTHER_LDFLAGS']
        if flags.is_a?(Array)
          config.build_settings['OTHER_LDFLAGS'] = flags - ['-l"GameCore"']
        elsif flags.is_a?(String)
          config.build_settings['OTHER_LDFLAGS'] = flags.gsub(/\s*-l"GameCore"\b/, '')
        end
      end
    end
  end
end
