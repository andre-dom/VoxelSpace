let project = new Project('Terrain');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addDefine('kha_html5_disable_automatic_size_adjust');
resolve(project);