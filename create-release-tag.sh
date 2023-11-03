#!/bin/bash

# Read the current version from pubspec.yaml
current_version=$(grep 'version:' pubspec.yaml | awk '{print $2}')

# Split the version into major, minor, and patch components
IFS="." read -ra version_parts <<< "$current_version"

major="${version_parts[0]}"
minor="${version_parts[1]}"
patch="${version_parts[2]}"

# Specify the type of release (major, minor, or patch)
release_type="minor"  # Change this as needed

# Increment the version based on the release type
if [ "$release_type" == "major" ]; then
  major=$((major + 1))
  minor=0
  patch=0
elif [ "$release_type" == "minor" ]; then
  minor=$((minor + 1))
  patch=0
else
  patch=$((patch + 1))
fi

# Create the new version
new_version="$major.$minor.$patch"
# Generate a unique tag based on the current date and time
tag="v$(date '+%Y%m%d%H%M%S')"

# Create and push the tag
git tag "$tag"
git push origin "$tag"

# Print the created tag to the terminal
echo "Created and pushed tag: $tag"
# Create a Git tag
git tag -a "v$new_version" -m "Version $new_version"
git push --tags
