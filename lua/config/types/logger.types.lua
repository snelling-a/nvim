-- @meta

--- @alias Message string?
--- @alias Title string?
--- @alias Level 0|1|2|3|4|5

--- @alias NotifyArgs {msg:Message?,title:Title?}
--- @alias Args Message|NotifyArgs|table
--- @alias LoggerArgs Args|string

--- @alias ConfirmArgs {msg:Message,choices:string,default:number,type:string}?

--- @class Log
--- @field new fun(self: Log, title: Title): Log
--- @field private log fun(self: Log, level: integer, args: LoggerArgs)
--- @field private get_logger_args fun(self: Log, args: Args): NotifyArgs
--- @field info fun(self: Log, args: LoggerArgs)
--- @field warn fun(self: Log, args: LoggerArgs)
--- @field error fun(self: Log, args: LoggerArgs)
--- @field confirm fun(self: Log, confirm_args: ConfirmArgs): number|nil confirmation
