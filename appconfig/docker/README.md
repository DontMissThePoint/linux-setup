** How to connect with freerdp command
- To connect to the remote desktop using xfreerdp, run a command of the form:
$ xfreerdp /f /u:USERNAME /p:PASSWORD /v:HOST[:PORT]

In this command:

/f is option means to open the remote desktop in full screen mode
/u:USERNAME is a name of the account on the computer to which we are connecting
/p:PASSWORD is a password of the specified account
/v:HOST[:PORT] is an IP address or name of the computer to which the remote table is connected. PORT optional (recommended: “Windows Computer name: how to change and use”)
For example, I want to open a remote computer desktop with IP address 192.168.0.101, on which there is a Tester user with a password of 1234, and I want to open a remote working collision in full screen mode, then the command is as follows:

$ xfreerdp /f /u:test /p:123 /v:192.168.30.100

- To toggle between full-screen and windowed modes, use the keyboard shortcut Ctrl+Alt+Enter.

When connecting for the first time, the following message about the problem with the certificate appears:
Since self-signed certificates are used without a private CA (authentication center, certification authority) added to the store, the only choice is to agree to trust the specified certificate, enter Y for this.
- In full screen mode, you can disconnect from the remote desktop in two ways:
+ press the cross on the top panel
+ Start button → Shutdown → Disconnect

- To run in windowed mode, do not use the /f option:
$ xfreerdp /u:test /p:123 /v:192.168.30.100

** Xfreerdp options
- The xfreerdp program has many options,I picked up the most interesting of them:

/v:server[:port]    Server hostname
/u:...  Username
/p:password  Password
/f              Fullscreen mode (Ctrl+Alt+Enter toggles fullscreen)
/port:number    Server port
/size:...    Screen size
/smart-sizing:1920x1080  scale for HiDPI screens
/w:width     Width
/h:height    Height
/monitor-list       List detected monitors
/monitors:id      Select monitors to use
-grab-keyboard          Disable Grab keyboard
-mouse-motion           Disable Send mouse motion
/log-filters:...    Set logger filters, see wLog(7) for details
/log-level:...  Set the default log level, see wLog(7) for details
+home-drive             Enable Redirect user home as share
/drive:name,path     Redirect directory [path] as named share name
+drives                 Enable Redirect all mount points as shares
/t:title       Window title
/ipv6                   Prefer IPv6 AAA record over IPv4 A record
/kbd:0xid or name    Keyboard layout
/kbd-fn-key:value    Function key value
/kbd-list               List keyboard layouts
/kbd-subtype:id   Keyboard subtype
/kbd-type:id      Keyboard type/id
How to connect to Windows remote desktop from ubuntu 20 04 using freerdp
------
How to create shared folders in freerdp
- With remote desktop connected via RDP, you can have shared folders. Let's look at a few examples.
- To connect all mount points in the current system as shared folders on the remote desktop, use the +drives option, for example:
$ xfreerdp /u:test /p:123 /v:192.168.30.100 +drives
The screenshot shows the remote Windows desktop, in which the Linux system folders are accessible:

- To connect only the home folder of the current Linux user as a network folder to the computer via RDP, specify the +home-drive option:
$ xfreerdp /u:test /p:123 /v:192.168.30.100 +home-drive

In this case, the home folder is mounted on a system connected via the remote desktop protocol:
- With the option /drive:NAME,/PATH/IN/LINUX, you can connect any folder with any name. The path in the current system must be specified as /PATH/IN/LINUX, and NAME is the name that will have the share in the remote system. For example, to connect the root folder of the current system (/) to the remote folder with the root name:
$ xfreerdp /u:test /p:123 /v:192.168.30.100 /drive:root,/

------
