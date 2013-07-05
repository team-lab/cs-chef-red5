action :install do
  tarball_name   = new_resource.url.split("/").last
  app_dir        = new_resource.dir
  app_dir_name   = ::File.basename(app_dir)
  parent_dir     = ::File.expand_path("..", app_dir)

  unless ::File.exists?(app_dir)
    unless ::File.exists?(parent_dir)
      Chef::Application.fatal!("'#{parent_dir}' does not exist!")
    end

    Chef::Log.info "Adding #{app_dir_name} to #{parent_dir}"
    require 'fileutils'

    r = remote_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
      source   new_resource.url
      checksum new_resource.checksum
      mode     0755
      action   :nothing
    end
    r.run_action(:create_if_missing)

    require 'tmpdir'

    tmpdir = Dir.mktmpdir
    case tarball_name
    when /^.*\.zip/
      cmd = Chef::ShellOut.new(
                         %Q[ unzip "#{Chef::Config[:file_cache_path]}/#{tarball_name}" -d "#{tmpdir}" ]
                               ).run_command
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
      end
    when /^.*\.tar.gz/
      cmd = Chef::ShellOut.new(
                         %Q[ tar xvzf "#{Chef::Config[:file_cache_path]}/#{tarball_name}" -C "#{tmpdir}" ]
                               ).run_command
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
      end
    end

    unzip_dir_name = Dir.entries(tmpdir).detect{|f|::File.directory?(::File.join(tmpdir,f)) and f!= "."  and f!= ".."}

    ::FileUtils.chown new_resource.user, new_resource.group, "#{tmpdir}/#{unzip_dir_name}"
    cmd = Chef::ShellOut.new(
                       %Q[ mv "#{tmpdir}/#{unzip_dir_name}" "#{app_dir}" ]
                             ).run_command
    unless cmd.exitstatus == 0
      Chef::Application.fatal!(%Q[ Command \' mv "#{tmpdir}/#{unzip_dir_name}" "#{app_dir}" \' failed ])
    end
    ::FileUtils.rm_r tmpdir
    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  Chef::Application.fatal!(
    "This Red5 cookbook does not support removing Red5 at this time")
end
