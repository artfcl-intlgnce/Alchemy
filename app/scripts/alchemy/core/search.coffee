# Alchemy.js is a graph drawing application for the web.
# Copyright (C) 2014  GraphAlchemist, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

alchemy.search = 
    init: () ->
        searchBox = alchemy.dash
                           .select "#search input"

        searchBox.on "keyup", ()->
            input = searchBox[0][0].value.toLowerCase()

            alchemy.vis
                   .selectAll ".node"
                   .classed "inactive", false
            alchemy.vis
                   .selectAll "text"
                   .attr "style", -> "display: inline;" if input != ""
            alchemy.vis
                   .selectAll ".node"
                   .classed "inactive", (node) ->
                       DOMtext = d3.select @
                                   .text()
   
                       switch alchemy.conf.searchMethod
                           when 'contains'
                               hidden = DOMtext.toLowerCase().indexOf(input) < 0
                           when 'begins'
                               hidden = DOMtext.toLowerCase().indexOf(input) != 0
   
                       if hidden
                           alchemy.vis
                                  .selectAll "[source-target*='#{node.id}']"
                                  .classed "inactive", hidden
                       else
                           alchemy.vis
                                  .selectAll "[source-target*='#{node.id}']"
                                  .classed "inactive", (edge)-> 
                                       nodeIDs = [edge.source.id, edge.target.id]
                                       
                                       sourceHidden = alchemy.vis.select("#node-#{nodeIDs[0]}").classed "inactive"
                                       targetHidden = alchemy.vis.select("#node-#{nodeIDs[1]}").classed "inactive"
                                       
                                       targetHidden or sourceHidden
                       hidden