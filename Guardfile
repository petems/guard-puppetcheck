group :specs do
  guard :rspec do
    watch(%r{spec/.+_spec.rb})
    watch(%r{lib/(.+)\.rb})    { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb') { "spec" }
  end
end

group :checking do
  guard :puppetcheck do
    watch(/(.*).pp$/)
  end
end




