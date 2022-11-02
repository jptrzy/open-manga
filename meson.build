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
]

sources = files(
	'src/App.vala',
	'src/OmFilesPreview.vala',
	'src/OmImagesPreview.vala',
)

sources += import( 'gnome' ).compile_resources(
	meson.project_name() + '.resources',
   join_paths('resources', meson.project_name() + '.gresource.xml'),
	source_dir: ['resources'],
)

executable('OpenManga', sources, dependencies: dependencies)
