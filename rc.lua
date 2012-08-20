-- Hacked from default rc.lua for shifty and more by Milk Miruku

-- Standard awesome library
require("awful")
require("awful.autofocus")
-- Theme handling library
require("beautiful")
-- Widgets
require("vicious")
-- Notification library
require("naughty")
-- shifty - dynamic tagging library
require("shifty")

-- useful for debugging, marks the beginning of rc.lua exec
print("Entered rc.lua: " .. os.time())

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
theme_path = "/home/milk/.config/awesome/themes/milk/theme.lua"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
browser = "chromium"
mail = "thunderbird"
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key, I suggest you to remap
-- Mod4 to another key using xmodmap or other tools.  However, you can use
-- another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Shifty tags
-- Define if we want to use titlebar on all applications.
use_titlebar = false

-- Shifty configured tags.
shifty.config.tags = {
     term = {
        init      = true,
        layout    = awful.layout.suit.tile.fair,
        mwfact    = 0.70,
        exclusive = true,
        position  = 1,
        screen    = 1,
    },
--    purple = {
--        layout    = awful.layout.suit.tile.fair,
--        mwfact    = 0.65,
--        position  = 2,
--        exclusive = true,
--    },
--    remote = {
--        layout    = awful.layout.suit.tile.fair,
--        mwfact    = 0.65,
--        position  = 3,
--        exclusive = true,
--    },
    web = {
        layout    = awful.layout.suit.tile.top,
        mwfact    = 0.55,
        position  = 4,
        exclusive = true,
    },
    files = {
        layout    = awful.layout.suit.float,
        position  = 5,
    },
    graphics = {
        layout   = awful.layout.suit.tile,
        position = 6,
    },
    office = {
        layout   = awful.layout.suit.tile,
        position = 7,
    }
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
    { match = { "urxvt"  },
        tag = "term" },
    { match = { "chrome" },
        tag = "web" },
    { match = { "google-chrome" },
        tag = "web" },
    { match = { "firefox" },
        tag = "web" },
    { match = { "luakit" },
        tag = "luakit" },

--    { match = { "@purple" },
--        tag = "purple" },
--    { match = { "@silver" },
--        tag = "silver" },
--    { match = { "ssh" },
--        tag = "remote" },

    { match = { "pcmanfm",
                "qtfm" },
        tag = "files" },

    { match = { "Fonty Python*",
                "gimp" },
        tag = "graphics" },

    { match = { "OpenOffice.*",
                "Abiword",
                "Gnumeric"  },
        tag = "office" },

    { match = { "Mplayer.*",
                "Mirage",
                "gtkpod",
                "Ufraw",
                "easytag"},
        tag = "media",
    nopopup = true },

    { match = { "vlc",
                "MPlayer",
                "sonata",
                "ario" },
        tag = "media",
      float = true },

    { match = { "Gnuplot",
                "galculator",
                "keepassx" },
        tag = "float",
      float = true,
   titlebar = true
    },

    { match = { "htop" },
        tag = "system"
    },

    { match = { terminal },
honorsizehints = false,
         slave = false
    },

    { match = {""},
        buttons = awful.util.table.join(
            awful.button({}, 1, function (c) client.focus = c; c:raise() end),
            awful.button({modkey}, 1, function(c) -- Switch to client on click
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
                end),
            awful.button({modkey}, 3, awful.mouse.client.resize) -- Mod+right mouse button for client drag resize
            )
    },
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile.bottom,
    ncol = 1,
    mwfact = 0.60,
    floatBars = true,
    guess_name = true,
    guess_position = true,
}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    {"manual", terminal .. " -e man awesome"},
    {"edit config",
     editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua"},
    {"restart", awesome.restart},
    {"quit", awesome.quit}
}

mymainmenu = awful.menu(
    {
        items = {
            {"awesome", myawesomemenu, beautiful.awesome_icon},
              {"open terminal", terminal}}
          })

mylauncher = awful.widget.launcher({image = image(beautiful.awesome_icon),
                                     menu = mymainmenu})
-- }}}

-- {{{ Wibox
-- Create a textbox widget
mytextclock = awful.widget.textclock({align = "right"})

-- Network usage widget
-- Initialize widget
netwidget = widget({type = "textbox", align = "right"})
-- Register widget
vicious.register(netwidget, vicious.widgets.net, ' | <span color="#CC9393">${eth0 down_kb} v</span> <span color="#9FaF9F">${eth0 up_kb} ^</span> | ', 3)

-- CPU usage widget
-- Initialize widget
cpuwidget = awful.widget.graph()
-- Graph properties
cpuwidget:set_width(50)
cpuwidget:set_height(16)
cpuwidget:set_background_color("#000000")
cpuwidget:set_color("#FF5656")
cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, "$1")

-- Create a systray
mysystray = widget({type = "systray", align = "right"})

-- Create a wibox for each screen and add it
mywibox = { }
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}                                                                -- Define tag interaction
mytaglist.buttons = awful.util.table.join(
    awful.button({}, 1, awful.tag.viewonly),                                  -- Left click on tag
    awful.button({modkey}, 1, awful.client.movetotag),                        -- 
    awful.button({}, 3, function(tag) tag.selected = not tag.selected end),   -- Send active window to right clicked tag
    awful.button({modkey}, 3, awful.client.toggletag),                        --
    awful.button({}, 5, awful.tag.viewnext),                                  -- Button 4, mousewheel up
    awful.button({}, 4, awful.tag.viewprev)                                   -- Button 5, mousewheel down
    )

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
        end),
    awful.button({}, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({width=250})
        end
        end),
-- {{{ mousewheel on screen edge goes out of window boundry and hides active, annoying. not caused by below?
    awful.button({}, 5, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
        end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
        end))
-- }}}

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] =
        awful.widget.prompt({layout = awful.widget.layout.leftright})
    -- Create an imagebox widget which will contains an icon indicating which
    -- layout we're using.  We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s,
                                            awful.widget.taglist.label.all,
                                            mytaglist.buttons)

-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.config.taglist = mytaglist
shifty.tag.init()
-- }}}

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                        return awful.widget.tasklist.label.currenttags(c, s)
                    end,
                                              mytasklist.buttons)

    -- Seperator
    seperator = widget({ type = "textbox" })
    seperator.text = " | "

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", height = "36", screen = s })

    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
          {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
          },
          {
            mylayoutbox[s],
            seperator,
            mytextclock,
            seperator,
            cpuwidget.widget,
            netwidget,
            s == 1 and mysystray or nil,
            layout = awful.widget.layout.horizontal.rightleft
          }
        },
        {
            mytasklist[s]
        },
        layout = awful.widget.layout.vertical.flex,
        height = mywibox[s].height
    }

    mywibox[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Global key bindings
globalkeys = awful.util.table.join(
    -- Tags
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore), -- switch back to previous tag used

    -- Shifty: keybindings specific to shifty
    awful.key({modkey,            }, "d", shifty.tag.del), -- delete a tag
    awful.key({modkey, "Shift"    }, "n", shifty.client.move.left), -- client to prev tag
    awful.key({modkey             }, "n", shifty.client.move.right), -- client to next tag
    awful.key({modkey, "Control"  }, "n", -- move tag to end of tag list
        function()
            local t = awful.tag.selected()
            local s = awful.util.cycle(screen.count(), t.screen + 1)
            awful.tag.history.restore()
            t = shifty.tag.move.screen(s, t)
            awful.tag.viewonly(t)
        end),
    awful.key({ modkey            }, "a", shifty.tag.add), -- creat a new tag
    awful.key({ modkey            }, "s", shifty.tag.rename), -- rename a tag
    awful.key({ modkey, "Shift"   }, "a", -- nopopup new tag
        function()
            shifty.tag.add({nopopup = true})
        end),
    awful.key({ modkey            }, "j",
        function()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey            }, "k",
        function()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey            }, "w", function() mymainmenu:show(true) end), -- broken?

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey            }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey            }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey            }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey            }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    awful.key({ modkey            }, "F10",   function () awful.util.spawn("import -window root /home/milk/documents/images/screenshots/silver-" .. os.time() .. ".png") end),

-- Yeganesh prompt (unfixed)
--    awful.key({ modkey                }, "r",
--      function()
--        awful.util.spawn("yeganesh -x")
--      end),

    -- Dmenu, http://awesome.naquadah.org/wiki/Using_dmenu
    awful.key({ modkey            }, "p",
       function ()
           awful.util.spawn("dmenu_run -i -p 'Run command:' -nb '" ..
           beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal ..
           "' -sb '" .. beautiful.bg_focus ..
           "' -sf '" .. beautiful.fg_focus .. "'")
      end),

    -- Basic prompt
    awful.key({ modkey            }, "r",
        function()
            awful.prompt.run({prompt = "Run: "},
            mypromptbox[mouse.screen].widget,
            awful.util.spawn, awful.completion.shell,
            awful.util.getdir("cache") .. "/history")
        end),

    awful.key({ modkey            }, "x",
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
        end),

-- Run or raise applications with dmenu
--    awful.key({ modkey }, "p",
--    function ()
--        local f_reader = io.popen( "dmenu_path | dmenu -b -nb '".. beautiful.bg_normal .."' -nf '".. beautiful.fg_normal .."' -sb '#955'")
--        local command = assert(f_reader:read('*a'))
--        f_reader:close()
--        if command == "" then return end
--
--        -- Check throught the clients if the class match the command
--        local lower_command=string.lower(command)
--        for k, c in pairs(client.get()) do
--            local class=string.lower(c.class)
--            if string.match(class, lower_command) then
--                for i, v in ipairs(c:tags()) do
--                    awful.tag.viewonly(v)
--                    c:raise()
--                    c.minimized = false
--                    return
--                end
--            end
--        end
--        awful.util.spawn(command)
--    end)

   awful.key({ modkey, "Control" }, "x", function () awful.util.spawn("xscreensaver-command -lock") end)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff
-- like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey            }, "f", function(c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey            }, "c", function(c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return",
        function(c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey            }, "o", awful.client.movetoscreen),
    awful.key({ modkey, "Shift"   }, "r", function(c) c:redraw() end),
    awful.key({ modkey            }, "t", awful.client.togglemarked),
    awful.key({ modkey            }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- SHIFTY: assign client keys to shifty for use in
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

-- Compute the maximum number of digit we need, limited to 9
for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey            }, i, function()
            local t =  awful.tag.viewonly(shifty.tag.get.by_position(i))
            end),
        awful.key({ modkey, "Control" }, i, function()
            local t = shifty.tag.get.by_position(i)
            t.selected = not t.selected
            end),
        awful.key({ modkey, "Control", "Shift" }, i, function()
            if client.focus then
                awful.client.toggletag(shifty.tag.get.by_position(i))
            end
            end),
        -- move clients to other tags
        awful.key({ modkey, "Shift" }, i, function()
            if client.focus then
                t = shifty.tag.get.by_position(i)
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
            end
        end))
    end

-- Set keys
root.keys(globalkeys)
-- }}}

-- Hook function to execute when focusing a client.
client.add_signal("focus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
client.add_signal("unfocus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)
