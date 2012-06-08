# encoding: utf-8
$:.unshift File.expand_path("../", __FILE__)

require 'chattin_api/version'

VERSION = File.open("VERSION") { |f| f.read }

# Inspired by `require_clean_work_tree'
# http://stackoverflow.com/questions/3878624
def work_tree_clean?
  `git update-index -q --ignore-submodules --refresh`
  if `git diff-files --quiet --ignore-submodules --` && !$?.success?
    false
  elsif `git diff-index --cached --quiet HEAD --ignore-submodules --` && !$?.success?
    false
  else
    true
  end
end

desc "Create tag v#{VERSION}"
task :tag do
  if work_tree_clean?
    sh "git tag v#{VERSION}"
    sh "git push origin v#{VERSION}"
  else
    fail "Your work tree isn't clean!"
  end
end
