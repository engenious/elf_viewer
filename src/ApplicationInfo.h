//
// SPDX-License-Identifier: MIT
// Copyright (c) Contributors to the elf_viewer Project.
//

#pragma once

#include <string>

namespace elfviewer
{

// This file is inspired by the book "Professional CMake: A Practical Guide" by Craig Scott. See
// https://crascit.com/professional-cmake/

/// The name of the application.
/// This uses a string view, and is ideal for zero copy access to the value.
///
const std::string_view&     getApplicationName();

/// The name of the application as a string.
///
const std::string&          getApplicationNameString();

/// A brief description of the application.
/// This uses a string view, and is ideal for zero copy read only access to the value.
///
const std::string_view&     getApplicationDescription();

/// A brief description of the application as a string.
///
const std::string&          getApplicationDescriptionString();

/// The hash of the git commit used when building.
///
const std::string_view&     getGitHash();

/// The full semantic version of this build.
/// This will be in the form major.minor.revision
const std::string_view&     getFullVersion();

/// The major version number of this build.
///
unsigned                    getMajorVersion();

/// The minor version number of this build.
///
unsigned                    getMinorVersion();

/// The patch version number of this build.
///
unsigned                    getPatchVersion();

} // namespace elfviewer

