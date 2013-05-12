#!/usr/bin/env ruby
require 'mathn'

def is_prime n
	('1' * n) !~ /^1?$|^(11+?)\1+$/
end

i = 1
n = 0
while true do
	i += 2
	n += 1
	p i if i.prime? != is_prime(i)
	p "#{i} (#{n})" if n % 1000 == 0
end

#require 'grit'
#r = Grit::Repo.new('/tmp/git/repositories/d1c8c486caf08ab20cae.git')
#r.fork_bare('/tmp/git/repositories/foo.git')
