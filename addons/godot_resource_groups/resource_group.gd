@tool
## A resource group is a set of resources in the project
## that you want to access at runtime.
@icon("resource_group.svg")
class_name ResourceGroup
extends Resource

const PathVerifier = preload("path_verifier.gd")

## The base folder for locating files in this resource group.
@export_dir var base_folder:String = ""
## Files that should be included. Can contain ant-style wildcards:
## ** - matches zero or more characters (including "/")
## * - matches zero or more characters (excluding "/")
## ? - matches one character
@export var includes:Array[String] = []

## Files which should be excluded. Is applied after the include filter.
## Can also contain ant-style wildcards.
@export var excludes:Array[String] = []

## The paths of the project that match this resource group.
@export var paths:Array[String] = []


## Loads all resources in this resource group and returns them.
func load_all() -> Array[Resource]:
	var result:Array[Resource] = []
	for path in paths:
		result.append(load(path))
	
	return result

## Gets all paths of resources inside of this resource group that
## match the given include and exclude criteria
func get_matching_paths(includes:Array[String], excludes:Array[String]) -> Array[String]:
	var path_verifier = PathVerifier.new(base_folder, includes, excludes)
	return paths.filter(func(it): return path_verifier.matches(it))

## Loads all resources in this resource group that match the given
## include and exclude criteria
func load_matching(includes:Array[String], excludes:Array[String]) -> Array[Resource]:
	var result:Array[Resource] = []
	var matching_paths = get_matching_paths(includes, excludes)
	for path in matching_paths:
		result.append(load(path))
		
	return result

## Loads all resources in this resource group and returns them
func load_all_dictionary(with_extension:bool = false) -> Dictionary:
	var result:Dictionary = {}
	for path in paths:
		if with_extension:
			result[path] = load(path)
		else:
			var path_without_extension = path.get_basename().get_basename()
			result[path_without_extension] = load(path)
	
	return result

## Gets all paths of resources inside of this resource group that
## match the given include and exclude criteria
func get_matching_paths_dictionary(includes:Array[String], excludes:Array[String], with_extension:bool = false) -> Dictionary:
	var dictionary:Dictionary = {}
	for path in get_matching_paths(includes, excludes):
		if with_extension:
			dictionary[path] = path
		else:
			var path_without_extension = path.get_basename().get_basename()
			dictionary[path_without_extension] = path
	
	return result

## Loads all resources in this resource group that match the given
## include and exclude criteria
func load_matching_dictionary(includes:Array[String], excludes:Array[String], with_extension:bool = false) -> Dictionary:
	var result:Dictionary = {}
	var matching_paths = get_matching_paths(includes, excludes)
	for path in matching_paths:
		if with_extension:
			result[path] = load(path)
		else:
			var path_without_extension = path.get_basename().get_basename()
			result[path_without_extension] = load(path)
		
	return result


# Workaround for C# interop not being able to properly convert arrays into Godot land.
func __csharp_get_matching_paths(includes:Array, excludes:Array) -> Array[String]:
	var includes_converted:Array[String] = []
	var	excludes_converted:Array[String] = []

	for include in includes:
		includes_converted.append(include)

	for exclude in excludes:
		excludes_converted.append(exclude)

	return get_matching_paths(includes_converted, excludes_converted)
	
	
# Workaround for C# interop not being able to properly convert arrays into Godot land.
func __csharp_load_matching(includes:Array, excludes:Array) -> Array[Resource]:
	var includes_converted:Array[String] = []
	var	excludes_converted:Array[String] = []
	
	for include in includes:
		includes_converted.append(include)
		
	for exclude in excludes:
		excludes_converted.append(exclude)
		
	return load_matching(includes_converted, excludes_converted)		
