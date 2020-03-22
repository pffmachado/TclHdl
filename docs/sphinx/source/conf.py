# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))

from recommonmark.parser import CommonMarkParser

# -- Project information -----------------------------------------------------

project = 'TCLHDL'
copyright = '2020, Paulo Machado'
author = 'Paulo Machado'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
        ]

extensions.append('sphinx.ext.todo')
extensions.append('sphinx.ext.autodoc')
extensions.append('sphinx.ext.intersphinx')
extensions.append('sphinx.ext.mathjax')
extensions.append('sphinx.ext.viewcode')
extensions.append('sphinx.ext.graphviz')
extensions.append('sphinx.ext.autodoc')
extensions.append('sphinx.ext.doctest')
extensions.append('sphinx.ext.coverage')
extensions.append('sphinx.ext.mathjax')
extensions.append('sphinx.ext.ifconfig')
extensions.append('sphinx.ext.githubpages')
extensions.append('sphinx.ext.autosectionlabel')
extensions.append('sphinxcontrib.plantuml')
extensions.append('breathe')

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinxdoc'
# html_theme = 'haiku'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# -- Setup Breathe ------------------------------------------------------------

breathe_projects = {
        "TCLHDL": "_doxygen/xml"
        }

breathe_default_project = "TCLHDL"

# -- Setup --------------------------------------------------------------------
def setup(app):
    app.add_source_suffix('.md', 'markdown')
    app.add_source_parser(CommonMarkParser)
    app.add_config_value('markdown_parser_config', {
        'auto_toc_tree_section': 'Content',
        'enable_auto_doc_ref': True,
        'enable_auto_toc_tree': True,
        'enable_eval_rst': True,
        'enable_inline_math': True,
        'enable_math': True,
    }, True)
