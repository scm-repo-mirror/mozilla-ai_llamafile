// -*- mode:c++;indent-tabs-mode:nil;c-basic-offset:4;coding:utf-8 -*-
// vi: set et ft=cpp ts=4 sts=4 sw=4 fenc=utf-8 :vi
//
// Copyright 2024 Mozilla Foundation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
// llamafile - Main entry point
//
// This is the main entry point for llamafile. It provides a TUI (Text User
// Interface) for interactive chatting with LLMs using the llama.cpp backend.
//
// Usage:
//   llamafile -m model.gguf              # Start TUI with model
//   llamafile -m model.gguf --mmproj ... # With vision model
//   llamafile -m model.gguf --chat       # TUI-only mode (no server)
//

#include "chatbot.h"

#ifdef COSMOCC
#include <cosmo.h>
#endif

int main(int argc, char **argv) {
#ifdef COSMOCC
    // Load arguments from zip file if present (for bundled llamafiles)
    argc = cosmo_args("/zip/.args", &argv);
#endif

    return lf::chatbot::main(argc, argv);
}
