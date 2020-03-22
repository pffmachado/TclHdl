#------------------------------------------------------------------------------
#-- Copyright (c) 2020 TclHdl
#-- 
#-- Permission is hereby granted, free of charge, to any person obtaining a copy
#-- of this software and associated documentation files (the "Software"), to deal
#-- in the Software without restriction, including without limitation the rights
#-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#-- copies of the Software, and to permit persons to whom the Software is
#-- furnished to do so, subject to the following conditions:
#-- 
#-- The above copyright notice and this permission notice shall be included in all
#-- copies or substantial portions of the Software.
#-- 
#-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#-- SOFTWARE.
#------------------------------------------------------------------------------
#-- Project  : TclHdl - Open HDL hub
#-- Author   : Paulo Machado <pffmachado@yahoo.com> 
#-- Filename : Makefile
#------------------------------------------------------------------------------
#-- File Description:
#--
#--
#--
#--
#------------------------------------------------------------------------------
#-- ChangeLog:
#--
#--
#--
#--
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Setup Environment
#------------------------------------------------------------------------------
PATH_ROOT	= $(PWD)
PATH_SRC	= $(PATH_ROOT)/src
PATH_TOOL	= $(PATH_ROOT)/tool
PATH_CMAKE	= $(PATH_ROOT)/cmake
PATH_DOCS	= $(PATH_ROOT)/docs

PATH_DOXYGEN  = $(PATH_DOCS)/doxygen
PATH_PLANTUML = $(PATH_DOCS)/plantuml
PATH_MARKDOWN = $(PATH_DOCS)/markdown
PATH_DOC      = $(PATH_DOCS)/doc
PATH_SPHINX   = $(PATH_DOCS)/sphinx

PATH_SPHINX_SOURCE       	= $(PATH_SPHINX)/source
PATH_SPHINX_BUILD       	= $(PATH_SPHINX)/build
PATH_SPHINX_BUILD_HTML  	= $(PATH_SPHINX_BUILD)/html

#------------------------------------------------------------------------------
#-- Generate Documentation
#------------------------------------------------------------------------------
cmakedoc:
	mkdir -p $(PATH_SPHINX_SOURCE)/_cmake; \
		cat $(PATH_CMAKE)/UseHdl.cmake | sed -n '/\[\.rst/,/#\]/p' | \
		sed '1d' | sed '$$d' >  $(PATH_SPHINX_SOURCE)/_cmake/UseHdl.rst

doxygen:
	mkdir -p $(PATH_SPHINX_SOURCE)/_doxygen; \
		cd $(PATH_DOXYGEN); \
		cp $(PATH_DOXYGEN)/Doxygen.rst $(PATH_SPHINX_SOURCE)/_doxygen; \
		doxygen Doxyfile

plantuml:
	mkdir -p $(PATH_SPHINX_SOURCE)/_images; \
		plantuml -tpng -o $(PATH_SPHINX_SOURCE)/_images $(PATH_PLANTUML)/*.puml

pandoc:
	mkdir -p $(PATH_SPHINX_SOURCE)/_markdown; \
		pandoc -s -t rst $(PATH_MARKDOWN)/Introduction.md -o $(PATH_SPHINX_SOURCE)/_markdown/Introduction.rst; \
		pandoc -s -t rst $(PATH_MARKDOWN)/TclHdl.md -o $(PATH_SPHINX_SOURCE)/_markdown/TclHdl.rst

doc:
	mkdir -p $(PATH_SPHINX_SOURCE)/_doc; \
        cp $(PATH_DOC)/*.rst $(PATH_SPHINX_SOURCE)/_doc

sphinx: cmakedoc doxygen plantuml doc
	cd $(PATH_SPHINX); \
		make html; \
		cp -r $(PATH_SPHINX_BUILD_HTML)/* $(PATH_DOCS); \
		cp -r $(PATH_SPHINX_SOURCE)/_doxygen/html $(PATH_DOCS)/_doxygen; \
		rm -rf $(PATH_SPHINX_BUILD); \
		rm -rf $(PATH_SPHINX_SOURCE)/_markdown; \
		rm -rf $(PATH_SPHINX_SOURCE)/_images; \
		rm -rf $(PATH_SPHINX_SOURCE)/_doc; \
		rm -rf $(PATH_SPHINX_SOURCE)/_breathe; \
		rm -rf $(PATH_SPHINX_SOURCE)/_doxygen; \
		rm -rf $(PATH_SPHINX_SOURCE)/_cmake

