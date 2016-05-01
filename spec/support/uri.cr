def should_be_same_uri(uri1, uri2)
  uri1.scheme.should eq uri2.scheme
  uri1.host.should eq uri2.host
  uri1.port.should eq uri2.port
  uri1.path.should eq uri2.path
  uri1.query.should eq uri2.query
end
