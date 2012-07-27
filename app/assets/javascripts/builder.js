/**
 *      Possible bonus a features
 * ---------------------------------------------------------------------
 * [ ] custom remote size
 * [ ] customizable left + right arrows
 * [ ] macros
 * 
 */

/*
 * Constants
 */
var GRID_SUBDIVISION = 2;
var GRID_SIZE = 36; // In px
var GRID_WIDTH = 7; // *GRID_SIZE px
var GRID_HEIGHT = 10; // *GRID_SIZE px
var BUTTON_SIZE = 36;
var IMAGE_SIZE = 34;

/**
 * This class defines a remote.
 */
function Remote(rid, rname, rbuttons) {
	var _id = rid; // Remote ID
	var _name = rname; // Remote name
	var _buttons = rbuttons; // List of Button
	
	return {
		id: function() {
			return _id;
		},
		name: function() {
			return _name;
		},
		buttons: function() {
			return _buttons;
		}
	}
}

/**
 * This class defines a button.
 */
function Button(bid, bicon, bx, by) {
	var _id = bid; // Button ID
	var _icon = bicon; // Button icon file name (path?)
	var _x = bx; // x position on remote
	var _y = by; // y position on remote
	
	return {
		id: function() {
			return _id;
		},
		icon: function() {
			return _icon;
		},
		x: function() {
			return _x;
		},
		y: function() {
			return _y;
		}
	}
}

/**
 * This class defines a device.
 */
function Device(did, dname, dbuttons) {
	// A device contains the same infos as a remote, (except for the buttons
	// that have no position). I create this class for clarity.
	return Remote(did, dname, dbuttons);
}

/**
 * Flashes !
 */
function flash(text) {
	var notice_bar = $("<div></div>");
	notice_bar.attr("id", "notice_bar").addClass("ui-corner-all").text(text);
	$("#flash_bar").children().remove();
	$("#flash_bar").append(notice_bar);
	notice_bar.fadeIn(3000).fadeOut(7000);
}

/**
 * Gets the list of remote for the current user.
 */
function getRemotes(populate) {
	var result = $.ajax({
		url: "/ajax/remotes", 
		success: function(result) {
			var remotes = new Array();
			$(result).find("remote").each(function(index, remote) {
				remotes.push(Remote($(remote).find("id").text(), $(remote).find("name").text(), $(remote).find("buttons")));
			});
			populate(remotes);
		},
		dataType: "xml"});
}

/**
 * Populate the body with links and remotes for current user.
 */
var remotes_created = false;
function populateRemotes(remotes) {
	if(tabs_created == false) {
		for (i in remotes) {
			addRemote(remotes[i]);
		}
		$("#home").page('destroy').page();
		tabs_created = true;
	}
}

/**
 * Add a given remote to the DOM.
 * @arg remote: remote to be displayed.
 */
function addRemote(remote) {
	var button = $("<a href='#remote-"+remote.id()+"'  data-transition='slide' data-role='button' data-icon='arrow-r' data-iconpos='right'>"+remote.name()+"</a>");
	$("#home .content").append(button);
	$("#home .content").append($("<br>"));
	$("#home").after(createDisplay(remote));
}

/**
 * Create a DOM element for the remote.
 * @arg remote: the remote to create.
 * @return: the created element.
 */
function createDisplay(remote) {
	var page = $("<div data-role='page' id='remote-"+remote.id()+"'><div data-role='header'><a data-icon='back' data-rel='back'>Back</a><h1>"+remote.name()+"</h1></div></div>");
	var content = $("<div data-role='content'></div>");
	if (remote.buttons() != undefined) {
		var buttonslist = $(remote.buttons().text()).css({"position": "absolute"});
		buttonslist.find("li").each(function(i,li) {
			$(li).addClass("ui-state-default ui-corner-all remote-button");
			$(li).css({"position": "absolute", "list-style": "none"});
			// TODO AJAX !
			var linkk = $("<a href='#' onClick='buttonClick("+$(li).attr("id")+");'></a>");
			$("img", li).wrap(linkk);
		});
		content.append(buttonslist);
	}
 	page.append(content);
	return page;
}

function buttonClick(buttonID) {
	$.ajax({
		url: "/remote/click", 
		data: "button_id="+buttonID,
		success: function(result) {},
		dataType: "xml"});
}

/**
 * Populate the #tab element with all the remotes for the current user.
 */
var tabs_created = false;
function populateTabs(remotes) {
	if(tabs_created == false)
	{
		flash("Remotes have been loaded");
		for (i in remotes) {
			addTab(remotes[i]);
		}
		var plus = $('<li class="ui-state-default ui-corner-top" id="plus-button"><a onclick="newTab()"><span>+</span></a></li>');
		$("#tabs-list").append(plus);
		$("#tabs").tabs({ closable: true });
		tabs_created = true;
	}
}

/**
 * Add a given tab to the DOM for the given remote.
 * @arg remote: remote to be displayed in the tab.
 */
function addTab(remote) {
	$("#tabs").append(createTab(remote));
	var tab = $("<li><a href='#tab-"+remote.id()+"'>"+remote.name()+"</a></li>");
	tab.addClass("tab_size_fixer");
	if ($("#plus-button").size()) {
		$("#plus-button").before(tab);
	} else {
		$("#tabs ul#tabs-list").append(tab);
	}
}

/**
 * Create a DOM element for the tab.
 * @arg remote: the remote to display in tab.
 * @return: the created element.
 */
function createTab(remote) {
	var tab = $("<div id='tab-"+remote.id()+"'></div>").addClass("ui-helper-`");
	tab.append(createRemote(remote.name(), remote.buttons()));
	return tab;
}

/**
 * Creates a remote element displaying given Buttons.
 * @arg name: name of the remote.
 * @arg buttons: list of Button to display in the remote.
 * @return: remote DOM element.
 */
function createRemote(name, buttons) {
	var remoteContainer = $("<div></div>").addClass("remote-container ui-corner-all");
	remoteContainer.css({"width": GRID_WIDTH*GRID_SIZE + "px", "height": (GRID_HEIGHT+1)*GRID_SIZE + "px"});
	var remote = $("<div></div>").addClass("remote");
	remote.css({"width": GRID_WIDTH*GRID_SIZE + "px", "height": GRID_HEIGHT*GRID_SIZE + "px"});
	remote.droppable({
		drop: function(event, ui) {
			remoteDrop(event, ui);
		},
		tolerance: "fit"
	});
	var span = $("<span>" + name + "</span>").click(function(event) {
		renameRemote(event);
	});
	var label = $("<div class='label'></div>").append(span);
	label.css({"width": GRID_WIDTH*GRID_SIZE + "px", "height": BUTTON_SIZE + "px"});
	remoteContainer.append(label);
	remoteContainer.append(remote);
	if (buttons != undefined) {
		var buttonslist = $(buttons.text()).addClass("buttons-list ui-helper-clearfix");
		buttonslist.find("li").each(function(i,li) {
			$(li).addClass("ui-state-default ui-corner-all remote-button");
			$(li).css({"position": "absolute"});
			$(li).draggable({
				grid: [GRID_SIZE/GRID_SUBDIVISION, GRID_SIZE/GRID_SUBDIVISION],
				revert: 'invalid',
				cursor: 'move'
			});
		});
		remote.append(buttonslist);
	}
	return remoteContainer;
}

/**
 * Gets the list of devices (for the current user).
 * @return: an array of Device.
 */
function getDevices() {
	var result = $.ajax({
		url: "/ajax/devices", 
		success: function(result) {
			var devices = new Array();
			$(result).find("device").each(function(index, device) {
				devices.push(Device($(device).find("id").text(), $(device).find("name").text(), $(device).find("buttons")));
			});
			populateLibrary(devices);
		},
		dataType: "xml"});
}

/**
 * Populates the #library with devices and their buttons.
 */
var lib_created = false;
function populateLibrary(devices) {
	if(lib_created == false)
	{
		$("#device-selector").change(function(event) {
			showList($(event.target));
		});
		for (i in devices) {
			addDevice(devices[i]);
		}
		$("#library").append(createTrash());
		$("#device-selector").change();
		lib_created = true;
	}
}

/**
 * Adds a .buttons_list for the given device to the #library.
 * @arg device: device for which to display buttons.
 */
function addDevice(device) {
	$("#device-selector").append($("<option>" + device.name() + "</option>").attr("value", "device-" + device.id()));
	var buttonslist = $(device.buttons().text()).addClass("buttons-list ui-helper-clearfix")
	.attr("id", "device-" + device.id());
	buttonslist.find("li").each(function(i,li) {
		$(li).addClass("ui-state-default ui-corner-all");
		$(li).addClass("library-button");
		$(li).draggable({
			helper: 'clone',
			cursor: 'move',
			cursorAt: { left: BUTTON_SIZE/2, top: BUTTON_SIZE/2 },
			zIndex: 2700
		});
	});
	$("#library").append(buttonslist);
}

/**
 * Creates the trash.
 * @return: DOM element.
 */
var trash_created = false;
function createTrash() {
	if(trash_created == false)
	{
		var trash = $("<div id='trash'></div>");
		trash.append($("<img src='../images/trash.png'>"));
		//trash.addClass("ui-state-default ui-corner-all");
		trash.droppable({
			accept: '.remote-button',
			drop: function(event, ui) {
				saveChange("remove", $(ui.draggable).attr("id"));
				$(ui.draggable).remove();
				$("#trash img").attr("src", "../images/trash.png");
			},
			tolerance: "pointer",
			over: function(event, ui) {
				$("#trash img").attr("src", "../images/trash_hover.png");
			},
			out: function(event, ui) {
				$("#trash img").attr("src", "../images/trash.png");
			}
		}).css({ zIndex: 100 });
		trash_created = true;
		return trash;
	}
}

/**
 * Event handler for when a button is dropped in a remote.
 * @arg event: fired event.
 * @arg ui: ui object.
 */
function remoteDrop(event, ui) {
	// If the object comes from the library only
	if ($(ui.draggable).hasClass('library-button')) {
		var clone = $(ui.draggable).clone();
		clone.removeClass("library-button").addClass("remote-button");
		var left = event.pageX-$("#tabs div:not(.ui-tabs-hide) .remote-container .remote").offset().left;
		left -= BUTTON_SIZE/2;
		left -= left%(GRID_SIZE/GRID_SUBDIVISION);
		var top = event.pageY-$("#tabs div:not(.ui-tabs-hide) .remote-container .remote").offset().top;
		top -= BUTTON_SIZE/2;
		top -= top%(GRID_SIZE/GRID_SUBDIVISION);
		clone.css({
			"position": "absolute",
			"left": left + "px",
			"top": top + "px"
		});
		clone.draggable({
			grid: [GRID_SIZE/GRID_SUBDIVISION, GRID_SIZE/GRID_SUBDIVISION],
			revert: 'invalid',
			cursor: 'move'
		});
		$("#tabs div:not(.ui-tabs-hide) .remote-container .remote .buttons-list").append(clone);
		saveChange("add", $(ui.draggable).attr("id"), left, top, clone);
	} else {
		saveChange("move", $(ui.draggable).attr("id"), Math.round($(ui.draggable).position().left), Math.round($(ui.draggable).position().top));
	}
}

/**
 * Shows only the buttons-list corresponding to the selected choice.
 * @arg option: selected option.
 */
function showList(option) {
	$("#library .buttons-list").hide();
	var deviceID = $("#device-selector option:selected").val();
    $("#" + deviceID).fadeToggle("slow");
}

/**
 * Saves the current remote state into the DB.
 * @arg action: what happened (remove, move, add).
 * @arg id: i of the button that changed.
 * @arg x: [optional] left position of the button.
 * @arg y: [optional] top position of the button.
 */
function saveChange(action, movedID, x, y, clone) {
	var remoteID = $("#tabs > div:not(.ui-tabs-hide)").attr("id").split(/-/)[1];
	switch (action) {
		case "add":
			/* AJAX-LIKE-QUERY :
			 * query("UPDATE TABLE RemoteButtons ADD (buttonID = id, buttonX = x, buttonY = y, remote = remoteID));
			 */
			 var result = $.ajax({
				url: "/ajax/update", 
				data: "type=button&user_action=add&remote_id="+remoteID+"&icon_id="+movedID+"&pos_x="+x+"&pos_y="+y,
				success: function(result) {
					$(clone).attr("id", $(result).find("id").text());
					$("#log").prepend("Remote " + remoteID + ": button " + movedID + " was added at [" + x + "," + y + "]<br />");
					flash("Button added");
				},
				dataType: "xml"});
			break;
		case "move":
			/* AJAX-LIKE-QUERY :
			 * query("UPDATE TABLE buttons (button= x, buttonY = y) WHERE remote=remoteID AND buttonID=id);
			 */
			 var result = $.ajax({
				url: "/ajax/update", 
				data: "type=button&user_action=move&button_id="+movedID+"&pos_x="+x+"&pos_y="+y,
				success: function(result) {
					$("#log").prepend("Remote " + remoteID + ": button " + movedID + " was moved to [" + x + "," + y + "]<br />");
					flash("Button moved");
				},
				dataType: "xml"});
			break;
		case "remove":
			/* AJAX-LIKE-QUERY :
			 * query("UPDATE TABLE buttons REMOVE * WHERE remote=remoteID AND buttonID=id);
			 */
			 var result = $.ajax({
				url: "/ajax/update", 
				data: "type=button&user_action=remove&button_id="+movedID,
				success: function(result) {
					$("#log").prepend("Remote " + remoteID + ": button " + movedID + " was removed<br />");
					flash("Button removed");
				},
				dataType: "xml"});
			break;
	}
}

/**
 * Inspired from Yassir Yahya : http://octalforty.com/articles/renaming-jquery-ui-tabs-with-validation
 * Change the remote name into a editable field to allow user to change it.
 * @arg event: event fired by the click on the remote name.
 */
function renameRemote(event) {
	var span = $(event.target);
	var oldName = span.html();
	var label = $(event.target).parent();
	var form = $("<form id='rename-remote-form'><input type='text' id='new-remote-name' value='" + oldName + "' /></form>");
	form.css({ "font-size": "14px" });
	span.after(form).remove();
	form.bind("submit", function(e) {
		changeName(true, $("#new-remote-name").val());
		e.preventDefault();
		return false;
	});
	$("body").bind("click", function(e) {
		if (!$(e.target).is("#remote-rename-form") && !$(e.target).is("#new-remote-name") && event.target != e.target) {
			changeName(false, oldName);
		}
	});
}

/**
 * Change the name of the remote (and tab), replace the field by the new name.
 * @arg action: if true, change has been made.
 * @arg name: new name of the remote (and tab)
 */
function changeName(action, name) {
	if (name == "" || name.length > 20) {
		name = "Untitled";
	}
	
	var remoteID = $("#tabs > div:not(.ui-tabs-hide)").attr("id").split(/-/)[1];
	
	if (action) {
		/* AJAX-LIKE-QUERY :
		 * query("UPDATE TABLE remotes (remoteName = name) WHERE remoteID = remoteID);
		 */
		$("#log").prepend("Remote " + remoteID + " name changed to " + name + "<br />");
		flash("Name changed");
	}
	
	var span = $("<span>" + name + "</span>").click(function(event) {
		renameRemote(event);
	});
	
	$("#rename-remote-form").after(span).remove();
	$("#tabs-list li.ui-tabs-selected a:first").html(name);
	$("body").unbind();
}

/**
 * Add both the tab and its content.
 */
function newTab() {
	/* AJAX-LIKE-QUERY :
	 * remote = query("UPDATE TABLE remotes ADD (remoteName = "New remote"));
	 */
	$("#log").prepend("A new remote has been added<br />");
	flash("Remote added");
	// ID has to be given by DB to avoid duplicates ! (doesn't always work with random :P)
	var remote = new Remote(Math.floor(Math.random()*101), "New remote");
	$("#tabs").tabs("destroy")
	addTab(remote);
	var index = $("#tabs-list").children().size()-2;
	$("#tabs").tabs({ closable: true });
	$("#tabs").tabs("select", index);
	$("#tabs div:not(ui-tabs-hide) .remote").append($("<ul class=\"buttons-list ui-helper-clearfix\"></ul>"));
}

function removeTab(id) {
	var remoteID = id.split(/-/)[1];
	/* AJAX-LIKE-QUERY :
	 * query("UPDATE TABLE remotes REMOVE (remoteID = remoteID));
	 */
	$("#log").prepend("Remote " + remoteID + " has been removed<br />");
	flash("Remote removed");
	$("#tabs").tabs("select", 0);
}

function initBuilder() {
	getRemotes(populateTabs);
	getDevices();
}

function initRemote() {
	getRemotes(populateRemotes);
}

