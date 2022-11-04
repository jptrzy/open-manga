project('xyz.jptrzy.open.manga', 'vala', 'c', 
	version: '0.0.1',
	license: 'GPL-3.0',
	meson_version : '>=0.60.0'
)

dependencies = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	dependency('gtk4'),
	dependency('libadwaita-1'),

	dependency('json-glib-1.0'),
	dependency('gee-0.8'),
]

resources = import( 'gnome' ).compile_resources(
	meson.project_name() + '.resources',
   join_paths('res', meson.project_name() + '.gresource.xml'),
	source_dir: 'res',
)

sources = files(
	run_command('find', '.', '-name', '*.vala').stdout().strip().split('\n')
)

executable(
	'OpenManga',
	resources,
	sources: sources,
	vala_args: ['--gresourcesdir=src/'],
	dependencies: dependencies,
	install: true,
)
