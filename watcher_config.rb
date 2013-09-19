watch("spec/(.*)\.rb") { |md| system("rspec #{md[0]}") }
watch("lib/(.*)\.rb")  { |md| system("rspec spec/") }
