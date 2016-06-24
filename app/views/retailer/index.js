<% pos =  Retailer::PER_PAGE * @offset.to_i %>
<% @retailers[0..Retailer::PER_PAGE - 1].each do |retailer| -%>
	$("#retailer_table").append('<%= escape_javascript render :partial => "retailer/retailer_records", :locals =>{:pos =>pos, :retailer => retailer} %>');
	<% pos = pos+1%>
<% end %>
<% if @retailers.count == Retailer::PER_PAGE %>
	$.get('/retailer/index', {offset : "<%=@offset.to_i+1%>", route : "<%=@route_search_param%>", retailer_name : "<%=@retailer_search_param%>", latitude : "<%=@latitude_search_param%>", longitude : "<%=@longitude_search_param%>", address: "<%=@address_search_param%>" });
<%else%>
  alert(" All the retailers loaded !");
<%end%>

