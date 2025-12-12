#-*-mode:makefile-gmake;indent-tabs-mode:t;tab-width:8;coding:utf-8-*-┐
#── vi: set noet ft=make ts=8 sw=8 fenc=utf-8 :vi ────────────────────┘

PKGS += LLAMAFILE_NEW

# ==============================================================================
# Version information
# ==============================================================================

LLAMAFILE_VERSION_STRING := 0.10.0-dev

# ==============================================================================
# Include paths
# ==============================================================================

LLAMAFILE_NEW_INCS := \
	-iquote llamafile_new \
	-iquote llama.cpp/common \
	-iquote llama.cpp/include \
	-iquote llama.cpp/ggml/include \
	-iquote llama.cpp/ggml/src \
	-iquote llama.cpp/ggml/src/ggml-cpu \
	-iquote llama.cpp/src \
	-iquote llama.cpp/tools/mtmd \
	-isystem llama.cpp/vendor \
	-isystem third_party

# ==============================================================================
# Compiler flags
# ==============================================================================

LLAMAFILE_NEW_CPPFLAGS := \
	$(LLAMAFILE_NEW_INCS) \
	-DLLAMAFILE_VERSION_STRING=\"$(LLAMAFILE_VERSION_STRING)\" \
    -DCOSMOCC=1

# ==============================================================================
# Source files - Highlight library
# ==============================================================================

LLAMAFILE_NEW_HIGHLIGHT_SRCS := \
	llamafile_new/highlight/color_bleeder.cpp \
	llamafile_new/highlight/highlight.cpp \
	llamafile_new/highlight/highlight_ada.cpp \
	llamafile_new/highlight/highlight_asm.cpp \
	llamafile_new/highlight/highlight_basic.cpp \
	llamafile_new/highlight/highlight_bnf.cpp \
	llamafile_new/highlight/highlight_c.cpp \
	llamafile_new/highlight/highlight_cmake.cpp \
	llamafile_new/highlight/highlight_cobol.cpp \
	llamafile_new/highlight/highlight_csharp.cpp \
	llamafile_new/highlight/highlight_css.cpp \
	llamafile_new/highlight/highlight_d.cpp \
	llamafile_new/highlight/highlight_forth.cpp \
	llamafile_new/highlight/highlight_fortran.cpp \
	llamafile_new/highlight/highlight_go.cpp \
	llamafile_new/highlight/highlight_haskell.cpp \
	llamafile_new/highlight/highlight_html.cpp \
	llamafile_new/highlight/highlight_java.cpp \
	llamafile_new/highlight/highlight_js.cpp \
	llamafile_new/highlight/highlight_julia.cpp \
	llamafile_new/highlight/highlight_kotlin.cpp \
	llamafile_new/highlight/highlight_ld.cpp \
	llamafile_new/highlight/highlight_lisp.cpp \
	llamafile_new/highlight/highlight_lua.cpp \
	llamafile_new/highlight/highlight_m4.cpp \
	llamafile_new/highlight/highlight_make.cpp \
	llamafile_new/highlight/highlight_markdown.cpp \
	llamafile_new/highlight/highlight_matlab.cpp \
	llamafile_new/highlight/highlight_ocaml.cpp \
	llamafile_new/highlight/highlight_pascal.cpp \
	llamafile_new/highlight/highlight_perl.cpp \
	llamafile_new/highlight/highlight_php.cpp \
	llamafile_new/highlight/highlight_python.cpp \
	llamafile_new/highlight/highlight_r.cpp \
	llamafile_new/highlight/highlight_ruby.cpp \
	llamafile_new/highlight/highlight_rust.cpp \
	llamafile_new/highlight/highlight_scala.cpp \
	llamafile_new/highlight/highlight_shell.cpp \
	llamafile_new/highlight/highlight_sql.cpp \
	llamafile_new/highlight/highlight_swift.cpp \
	llamafile_new/highlight/highlight_tcl.cpp \
	llamafile_new/highlight/highlight_tex.cpp \
	llamafile_new/highlight/highlight_txt.cpp \
	llamafile_new/highlight/highlight_typescript.cpp \
	llamafile_new/highlight/highlight_zig.cpp \
	llamafile_new/highlight/util.cpp

# ==============================================================================
# Source files - Core TUI
# ==============================================================================

LLAMAFILE_NEW_SRCS_C := \
	llamafile_new/bestline.c \
	llamafile_new/llamafile.c \
	llamafile_new/zip.c

LLAMAFILE_NEW_SRCS_CPP := \
	llamafile_new/chatbot_comm.cpp \
	llamafile_new/chatbot_comp.cpp \
	llamafile_new/chatbot_eval.cpp \
	llamafile_new/chatbot_file.cpp \
	llamafile_new/chatbot_help.cpp \
	llamafile_new/chatbot_hint.cpp \
	llamafile_new/chatbot_hist.cpp \
	llamafile_new/chatbot_logo.cpp \
	llamafile_new/chatbot_main.cpp \
	llamafile_new/chatbot_repl.cpp \
	llamafile_new/compute.cpp \
	llamafile_new/datauri.cpp \
	llamafile_new/image.cpp \
	llamafile_new/llama.cpp \
	llamafile_new/string.cpp \
	llamafile_new/xterm.cpp \
	$(LLAMAFILE_NEW_HIGHLIGHT_SRCS)

# ==============================================================================
# Object files
# ==============================================================================

LLAMAFILE_NEW_OBJS := \
	$(LLAMAFILE_NEW_SRCS_C:%.c=o/$(MODE)/%.o) \
	$(LLAMAFILE_NEW_SRCS_CPP:%.cpp=o/$(MODE)/%.o)

# ==============================================================================
# Dependency libraries
# ==============================================================================

# Dependencies from llama.cpp/BUILD.mk:
#   GGML_OBJS   - Core tensor operations
#   LLAMA_OBJS  - LLM inference
#   COMMON_OBJS - Common utilities (arg parsing, sampling, chat templates)
#   MTMD_OBJS   - Multimodal support (vision models)
#   HTTPLIB_OBJS - HTTP client support for downloads
# Dependencies from llamafile/highlight/BUILD.mk:
#   We only need the gperf-generated keyword dictionary objects, not the
#   highlight cpp files (since we have our own copies in llamafile_new/highlight)

LLAMAFILE_NEW_HIGHLIGHT_GPERF_FILES := $(wildcard llamafile/highlight/*.gperf)
LLAMAFILE_NEW_HIGHLIGHT_KEYWORDS := $(LLAMAFILE_NEW_HIGHLIGHT_GPERF_FILES:%.gperf=o/$(MODE)/%.o)

# Server objects for llamafile_new (compiled with -DLLAMAFILE_TUI to exclude standalone main)
# Note: server.cpp is compiled separately below with LLAMAFILE_TUI defined
LLAMAFILE_NEW_SERVER_SUPPORT_OBJS := \
	o/$(MODE)/llama.cpp/tools/server/server-common.cpp.o \
	o/$(MODE)/llama.cpp/tools/server/server-context.cpp.o \
	o/$(MODE)/llama.cpp/tools/server/server-http.cpp.o \
	o/$(MODE)/llama.cpp/tools/server/server-models.cpp.o \
	o/$(MODE)/llama.cpp/tools/server/server-queue.cpp.o \
	o/$(MODE)/llama.cpp/tools/server/server-task.cpp.o

LLAMAFILE_NEW_DEPS := \
	$(GGML_OBJS) \
	$(LLAMA_OBJS) \
	$(COMMON_OBJS) \
	$(MTMD_OBJS) \
	$(HTTPLIB_OBJS) \
	$(LLAMAFILE_NEW_SERVER_SUPPORT_OBJS) \
	$(LLAMAFILE_NEW_HIGHLIGHT_KEYWORDS) \
	o/$(MODE)/third_party/stb/stb_image_resize2.o

# ==============================================================================
# Server integration
# ==============================================================================

# Include paths needed for server compilation
LLAMAFILE_NEW_SERVER_INCS := \
	$(LLAMAFILE_NEW_INCS) \
	-iquote llama.cpp/tools/server \
	-iquote o/$(MODE)/llama.cpp/tools/server

# Compile server.cpp with -DLLAMAFILE_TUI to exclude standalone main()
o/$(MODE)/llamafile_new/server.cpp.o: llama.cpp/tools/server/server.cpp $(SERVER_ASSETS)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(LLAMAFILE_NEW_CPPFLAGS) $(LLAMAFILE_NEW_SERVER_INCS) -DLLAMAFILE_TUI -c -o $@ $<

# ==============================================================================
# Main executable
# ==============================================================================

o/$(MODE)/llamafile_new/main.o: llamafile_new/main.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(LLAMAFILE_NEW_CPPFLAGS) -c -o $@ $<

o/$(MODE)/llamafile_new/llamafile: \
		o/$(MODE)/llamafile_new/main.o \
		o/$(MODE)/llamafile_new/server.cpp.o \
		$(LLAMAFILE_NEW_OBJS) \
		$(LLAMAFILE_NEW_DEPS) \
		$(SERVER_ASSETS)
	@mkdir -p $(@D)
	$(CXX) $(LDFLAGS) -o $@ $(filter %.o,$^) $(LDLIBS)

# ==============================================================================
# Pattern rules for llamafile_new sources
# ==============================================================================

o/$(MODE)/llamafile_new/%.o: llamafile_new/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(LLAMAFILE_NEW_INCS) -c -o $@ $<

o/$(MODE)/llamafile_new/%.o: llamafile_new/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(LLAMAFILE_NEW_CPPFLAGS) -c -o $@ $<

o/$(MODE)/llamafile_new/highlight/%.o: llamafile_new/highlight/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(LLAMAFILE_NEW_CPPFLAGS) -c -o $@ $<

# ==============================================================================
# Targets
# ==============================================================================

.PHONY: llamafile_new
llamafile_new: o/$(MODE)/llamafile_new/llamafile
