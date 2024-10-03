---@meta

---@class char: string

---@class JavaObject : any
---@field [any] any

---@class JavaClass : any
---@field [any] any

---@class ScriptEvent: JavaObject
---@field ignoreCancelled boolean Specifies whether the event handler should be invoked if the event has been cancelled by a previous handler.
---@field priority fun(priority: integer|JavaObject):ScriptEvent Set the priority of the event. Name or id can be used. Priorites: LOWEST(0), LOW(1), NORMAL(2), HIGH(3), HIGHEST(4), MONITOR(5)
---@field unregister fun() Unregisters the event.

---@class ScriptCommand: JavaObject
---Sets the tab completion handler
---@field complete fun(completionHandler: fun(completions: JavaObject, sender: JavaObject, args: string[])): ScriptCommand
---Sets the command's permission
---@field permission fun(permission: string|"op"): ScriptCommand
---Sets the command's aliases
---@field aliases fun(aliases: string[]): ScriptCommand
---Sets the command's description
---@field description fun(description: string): ScriptCommand
---
---@field tabCompletePlayers boolean
---@field setPermission fun(permission: string|"op")
---@field tabCompletionHandler fun(completions: JavaObject, sender: JavaObject, args: table<number, string>)

---@class ScriptTask: JavaObject
---@field cancel fun()

---@param obj JavaObject The object to cast.
---@param clazz JavaClass The class to cast the object to.
---@return JavaObject casted
---@nodiscard
function cast(obj, clazz) end

---Gets a java class.
---@param className string ex. `com.example.Example`.
---@return JavaClass class
---@nodiscard
function classFor(className) end

---Compares the type of two java objects.
---Supports lua types, tho it may produce an unexpected output.
---@param type1 JavaClass|JavaObject|any
---@param type2 JavaClass|JavaObject|any
---@param exact boolean? Not to check for subclasses.
---@return boolean
---@nodiscard
function instanceof(type1, type2, exact) end

---Creates an array
---@param type JavaClass Class type of the array.
---@param length integer Length of the array.
---@param ... any Items to add to the array.
---@return JavaObject
---@nodiscard
function makeArray(type, length, ...) end

---Registers a new event
---@generic T : JavaObject
---@param eventClass T The class of the event.
---@param handler fun(event: T) The event handler.
---@param priority number? The priority of the event handler.
---@return ScriptEvent event
function addEvent(eventClass, handler, priority) end

---Registers a new command.
---
---### Example
---```lua
---local Player = classFor("org.bukkit.entity.Player")
---
---local command = addCommand("foo", function(sender, args)
---    if instanceof(sender, Player) then
---        sender.sendMessage("You're a player!")
---    end
---
---    if #args == 0 then
---        sender.sendMessage("No arguments provided!")
---    end
---
---    sender.sendMessage("Bar!")
---end)
---
---command.tabCompletePlayers = true
---
---command.tabCompletionHandler = function(completions, sender, args)
---    local argCount = #args
---
---    if argCount == 0 then
---        completions.add("apple")
---    elseif argCount == 1 then
---        completions.add("balls")
---    else
---        if args[1] == "apple" then
---            completions.add("water")
---        else
---            if sender.isOp() then
---                completions.add("op")
---            else
---                completions.add("notOP")
---            end
---        end
---    end
---end
---```
---
---@param name string|string[] Name of the command in-game.
---@param handler fun(sender: JavaObject, args: string[]) The executed handler when the command is ran.
---@return ScriptCommand command
function addCommand(name, handler) end

---Executes a function at specified intervals.
---@param interval number The interval in ticks at which the callback should be executed
---@param cb fun() The function that is executed every interval
---@return ScriptTask task
function every(interval, cb) end

---Executes a function after a specified delay.
---@param delay number The delay in ticks at which the callback should be executed after
---@param cb fun() The function that is executed after the delay has passed
---@return ScriptTask task
function wait(delay, cb) end

---Executes a Lua function that iterates over a Java Iterable object.
---If the first argument is not an Iterable, returns nil.
---@param iterable JavaObject
---@return fun():any
---@nodiscard
function forEach(iterable) end

---Runs a function asynchronously
---@param cb any
function async(cb) end
