(function(){var a=Handlebars.template,b=Handlebars.templates=Handlebars.templates||{};b.weather=a(function(a,b,c,d,e){return c=c||a.helpers,'<div id="weather-models-app">\n  <div id="loader">\n    <div id="message"></div>\n  </div>\n  <select name="weathertype" class="ui-state-default"><option>Stochastic Weather Generation</option>\n    <option disabled="disabled">Downscaled Climate Scenario</option></select>\n  <p><strong>Specify Amount Change</strong>\n    <br>Please select values below for changes driving stochastically generated weather.\n  </p>\n  <p>\n    \n    <p>Mean Annual Precipitation (% change, 80-year mean) [<span id="precip01-value"></span>%]</p>\n    <div id="precip01"></div>\n    \n    <p>Precipitation Annual Variance (% change, 80-year mean) [<span id="precip02-value"></span>%]</p>\n    <div id="precip02"></div>\n\n    <p>Mean Annual Temperature (&deg;C change, 80-year mean) [<span id="mean-temp-value"></span>]</p>\n    <div id="mean-temp"></div>\n  </p>\n  <p>\n    <a id="run" href="#">Run Model</a>\n  </p>\n</div>\n'}),b["environmental-models"]=a(function(a,b,c,d,e){return c=c||a.helpers,'<div id="environmental-models-app">\n             <p align="center"><strong>Directly specify stream flow and temperature changes</strong></p>\n             <p>Streamflow (% change): 0%</p>\n             <div class="nullslider1"></div>\n             <p>Stream temperature (% change): 0%</p>\n             <div class="nullslider1"></div>\n             <p align="center">\n             <input class="nullbutton" value="Run Stream Models" type="submit">\n	         </p>\n</div>'}),b["land-use-models"]=a(function(a,b,c,d,e){return c=c||a.helpers,'<div id="land-use-models-app">\n             <p align="center"><input class="nullbutton" value="Launch Barrier Module" type="submit">\n             <p>Riparian cover (% change): 0%\n             <div class="nullslider1"></div>\n             <p>Impervious surface area (% change): 0%\n             <div class="nullslider1"></div>\n             <p align="center"><input class="nullbutton" value="Run Land Use Model" type="submit">\n	      </p>\n</div>'}),b["fish-models"]=a(function(a,b,c,d,e){return c=c||a.helpers,'         <div id="fish-models-app">\n         \n         		<table width="95%" border="0" cellspacing="0" cellpadding="0" style="font-size:12px">\n                      <tr>\n                        <td></td>\n                        <td colspan="2" align="center" width="30"><strong>Growth</strong></td>\n                        <td width="30">&nbsp;</td>\n                        <td colspan="2" align="center" width="30"><strong>Survival</strong></td>\n                      </tr>\n                      <tr>\n                      	<td></td>\n                      	<td align="left">0</td>\n                        <td align="right">1</td>\n                        <td></td>\n                      	<td align="left">0</td>\n                        <td align="right">1</td>\n                      <tr>\n                      	<td>Spring</td>\n                        <td colspan="2" align="center"><div class="nullslider2"></div></td>\n                        <td></td>\n                        <td colspan="2" align="center"><div class="nullslider2"></div></td>\n                      </tr>\n                      <tr>\n                      	<td>Summer</td>\n                        <td colspan="2" align="center"><div class="nullslider2"></div></td>\n                        <td></td>\n                        <td colspan="2" align="center"><div class="nullslider2"></div></td>\n                      </tr>                      \n                      <tr>\n                      	<td>Fall</td>\n                        <td colspan="2" align="center"><div class="nullslider2"></div></td>\n                        <td></td>\n                        <td colspan="2" align="center"><div class="nullslider2"></div></td>\n                      </tr>                      \n                      <tr>\n                      	<td>Winter</td>\n                        <td colspan="2" align="center"><div class="nullslider2"></div></td>\n                        <td></td>\n                        <td colspan="2" align="center"><div class="nullslider2"></div></td>\n                      </tr>\n                      <tr><td>&nbsp;</td></tr>\n                      <tr><td colspan="6" align="center">\n                      	<input type="submit"  class="nullbutton" name="fishmodel" value="Run Fish Model" >\n                      </td></tr>\n                </table>\n\n	         \n	</div>'})})()