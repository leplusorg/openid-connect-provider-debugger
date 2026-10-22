rockspec_format = "3.0"
package = "openid-connect-provider-debugger"
version = "0.0.0-1"
source = {
   url = "git://github.com/leplusorg/openid-connect-provider-debugger.git"
}
-- The versions of all the dependencies (including transitive ones) are pinned
-- in luarocks.lock, which takes precedence over any constraint declared here.
dependencies = {
   "lua-resty-openidc"
}
