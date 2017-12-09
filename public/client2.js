// Übergabeparameter für HTTP Methoden
var mieter = "/tenant";
var schwarzesBrett = "/SB";
var forum = "/forum";

// used to store UUID in case browser does not support sessionStorage
let sessionID = "";

// onClick Funktionalität der Menü Leiste
$('body').on('click', '#btn-mieter-load', e=> loadMieter());
$('body').on('click', '#btn-SB-load', e=> loadSB());
$('body').on('click', '#btn-forum-load', e=> loadForum());

// HTTP Methoden

// LOGIN

function postLogin(username, psw){
    console.log(psw);
	var request = new XMLHttpRequest();
   	request.open("POST","/login");
   	request.setRequestHeader("Content-type","application/json");
   	request.addEventListener('load', function(event) {
      	if (request.status == 200) {
            if (typeof(Storage) !== "undefined") {
                sessionStorage.setItem("sessionID", request.responseText);
            } else {
                sessionID = request.responseText;
            }
          	hideLogin();
          	loadAllItems(mieter);
          	addActionButton("addMieter");
          	updateNavBar();
          	getObjects();
      	} else {
        	console.error(request.statusText, request.responseText);
      	}
   	});
   	var newItem = { 
		username: username,
		psw: psw
   	};
   	request.send(JSON.stringify(newItem));
}

// GET OBJEKT INFO
function getObjects() {
    var request = new XMLHttpRequest();
    request.setRequestHeader("session",getSessionId());
    request.open("GET", "object/");
    request.addEventListener('load', function(event) {      // CALLBACK aufruf erst wenn LOAD rückgabe.
        if (request.status === 200) {
            var objectData = JSON.parse(request.responseText);
            sessionStorage.setItem("objectData", objectData);
            console.error(request.statusText, request.responseText);
        }
    });
    request.send();
}


function getItems(itemCategorie, callback){
    var request = new XMLHttpRequest();
    request.setRequestHeader("session",getSessionId());
    request.open("GET", itemCategorie);
    request.addEventListener('load', function(event) {      // CALLBACK aufruf erst wenn LOAD rückgabe.
        if (request.status == 200) {
            var data = JSON.parse(request.responseText);
            console.info(data);
            callback(data);
        } else {
            console.error(request.statusText, request.responseText);
        }
    });
    request.send();     // wird asugeführt auch wen eventlistener noch nicht load
}

function getItem(itemCategorie, id, callback){
    var request = new XMLHttpRequest();
    request.open("GET", itemCategorie + "/" + id);
    request.setRequestHeader("session",getSessionId());
    request.addEventListener('load', function(event) {      // CALLBACK aufruf erst wenn LOAD rückgabe.
        if (request.status === 200) {
            var data = JSON.parse(request.responseText);
            console.info(data);
            callback(data);
        } else {
            console.error(request.statusText, request.responseText);
        }
    });
    request.send();     // wird asugeführt auch wen eventlistener noch nicht load
}

function deleteItem(itemCategorie, id){
	var request = new XMLHttpRequest();
    $('.item-card-container').filter('[item-id='+id+']').remove();
   	request.open("DELETE", itemCategorie + "/" + id);
    request.setRequestHeader("session",getSessionId());
   	request.addEventListener('load', function(event) {
      	if (request.status == 200) {
        	console.info(request.responseText);
      	} else {
         	console.error(request.statusText, request.responseText);
      	}
   	});
	request.send();
}

function addMieter(firstName, lastName, adress, plz, city, mail, tel, mobil, qrCodeData){
	var request = new XMLHttpRequest();    r
   	request.open("POST","/tenant");
   	request.setRequestHeader("Content-type","application/json");
    request.setRequestHeader("session",getSessionId());
   	request.addEventListener('load', function(event) {
      	if (request.status == 200) {
        	console.info(request.responseText);
          	var data = JSON.parse(request.responseText);
          	addMieterToList(data);
      	} else {
        	console.error(request.statusText, request.responseText);
      	}
   	});
   	var newItem = { 
		firstName: firstName,
		lastName: lastName,
		adress: adress,
		plz: plz,
		city: city,
		mail: mail,
		tel: tel,
		mobil: mobil,
		qrCodeData: qrCodeData
   	};
   	request.send(JSON.stringify(newItem));
}

function editMieter(id, firstName, lastName, adress, plz, city, mail, tel, mobil) {
    var request = new XMLHttpRequest();
    request.open("POST","/tenant/" + id);
    request.setRequestHeader("Content-type","application/json");
    request.setRequestHeader("session",getSessionId());
    request.addEventListener('load', function(event) {
        if (request.status == 200) {
            console.info(request.responseText);
            var data = JSON.parse(request.responseText);
            updateTenantCard(data);
        } else {
            console.error(request.statusText, request.responseText);
        }
    });
    const newItem = {
        id: id,
        firstName: firstName,
        lastName: lastName,
        adress: adress,
        plz: plz,
        city: city,
        mail: mail,
        tel: tel,
        mobil: mobil
    };
    request.send(JSON.stringify(newItem));
}

function addSchwarzesBrettNachricht(titel, verfasser, erstellDatumISO, erstellDatumFormated, erstellZeit, verfallsDatum, nachricht){
	var request = new XMLHttpRequest();
   	request.open("POST","/SB");
   	request.setRequestHeader("Content-type","application/json");
    request.setRequestHeader("session",getSessionId());
    request.addEventListener('load', function(event) {
      	if (request.status == 200) {
        	console.info(request.responseText);
          	var data = JSON.parse(request.responseText);
          	addSBToList(data);
      	} else {
        	console.error(request.statusText, request.responseText);        	
      	}
   	});
   	var newItem = { 
		titel: titel,
		verfasser: verfasser,
		erstellDatumISO: erstellDatumISO,
		erstellDatumFormated: erstellDatumFormated,
		erstellZeit: erstellZeit,
		verfallsDatum: verfallsDatum,
		nachricht: nachricht
   	};
   	request.send(JSON.stringify(newItem));
}

function getForumItemsByCategory(categoryId) {
    var request = new XMLHttpRequest();
    request.setRequestHeader("session",getSessionId());
    request.open("GET", "forum/" + categoryId);
    request.addEventListener('load', function(event) {      // CALLBACK aufruf erst wenn LOAD rückgabe.
        if (request.status === 200) {
            var data = JSON.parse(request.responseText);
            console.info(data);
            callback(data);
        } else {
            console.error(request.statusText, request.responseText);
        }
    });
    request.send();
}

// Gets inputData from input form
function getLoginInputData() {
	const userName = $('#username').val();
	const psw = $('#password').val();
	const sha256 = new jsSHA('SHA-256', 'TEXT');
	sha256.update(psw);
	const shaPsw = sha256.getHash('HEX');
	const data = {
		username : userName,
		password : shaPsw
	};
	return data;
}

//Hides the LOGIN field after succesfull login
function hideLogin() {
	$('#login-container').hide();
}

// Speichert die Eingabedaten des "Mieter hinzufügen" Feldes
function getInputData() {
	fn = $("#first_name").val();
	ln = $("#last_name").val();
	adr = $("#mieter_adr").val();
	plz = $("#plz").val();
	city = $("#ort").val();
	mail = $("#email").val();
	tel = $("#telpriv").val();
	mob = $("#mobil").val();
	qrData = fn + ln + adr;
	$("#modal-mieter-fn").text(fn);
	$("#modal-mieter-ln").text(ln);
	$("#modal-mieter-adr").text(adr);
	$("#modal-mieter-city").text(city);
	$("#modal-mieter-plz").text(plz);
	$("#modal-mieter-mail").text(mail);
	$("#modal-mieter-telpriv").text(tel);
	$("#modal-mieter-mobil").text(mob);
}

function getEditedTenantData() {
    fn = $("#modal-edit-tenant-fn").text();
    ln = $("#modal-edit-tenant-ln").text();
    adr = $("#modal-edit-tenant-adr").text();
    plz = $("#modal-edit-tenant-plz").text();
    city = $("#modal-edit-tenant-city").text();
    mail = $("#modal-edit-tenant-mail").text();
    tel = $("#modal-edit-tenant-telpriv").text();
    mob = $("#modal-edit-tenant-mobil").text();
}

function updateTenantCard(data) {
    const nameField = '.mieter-card-name.' + data.id;
    const adrField = '.mieter-card-adr.' + data.id;
    const mailField = '.mieter-card-mail.' + data.id;
    const telField = '.mieter-card-tel.' + data.id;
    const mobilField = '.mieter-card-mobil.' + data.id;
    $(nameField).text(data.firstName + ' ' + data.lastName);
    $(adrField).text(data.adress + ', ' + data.plz + ' ' + data.city);
    $(mailField).text(data.mail);
    $(telField).text(data.tel);
    $(mobilField).text(data.mobil);
}

// Aufruf der HTTP POST Methode und einfügen der Daten in MieterCard zur Darstellung im HtmL
function saveMieterAndConfirm() {
	$("#card-title").text(fn + " " + ln);
	$("#card-str").text(adr + ", " + plz + " " + city);
	$("#card-mail").text(mail);
	$("#card-tel").text(tel);
	$("#card-mobil").text(mob);
	// var qrURL = generateQRCodeURL(fn, ln, adr);
	// var qr = document.getElementById("qr-code");
	// qr.src = qrURL;
	addMieter(fn, ln, adr, plz, city, mail, tel, mob, qrData);
}

function generateQRCodeURL(fn, ln, adr) {
	return "http://api.qrserver.com/v1/create-qr-code/?data=" + fn + ln + adr + "&size=200x200";
}

// Aufruf der HTTP POST Methode für das Schwarze Brett
function saveSchwarzesBrettEntry() {
	var titel = $("#SB-titel").val();
	var nachricht = $("#SB-nachricht").val();
	var verfasser = "user1";
	var erstellDatumISO = getCurrentDate()[0];
	var erstellDatumFormated = getCurrentDate()[1];
	var erstellZeit = getCurrentTime();
	var verfallsDatum = $('#verfallsDatum-datePicker').val();	
	addSchwarzesBrettNachricht(titel, verfasser, erstellDatumISO, erstellDatumFormated, erstellZeit, verfallsDatum, nachricht);
	// addSBItemsToList(titel, verfasser, erstellDatumISO, erstellDatumFormated, erstellZeit, verfallsDatum, nachricht);
}

function getCurrentDate() {
	var date = new Date();
	var day = date.getDate();
	var monthNum = date.getMonth();
	var month = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];
	var year = date.getFullYear();
	var resultISO = year + "-" + monthNum + 1 + "-" + day;
	var resultFormated = day + ". " + month[monthNum] + " " + year;
	var dateArray = [resultISO, resultFormated];
	return dateArray;
}

function getCurrentTime() {
	var date = new Date();
	var hour = date.getHours();
	var minutes = date.getMinutes();
	var seconds = date.getSeconds();
	var result = hour + ":" + minutes + ":" + seconds;
	return result;
}

// Speichert die ID des HTML Elements von dem aus ein Löschaufruf gestartet wurde
function saveTargetId(id) {
	itemId = id;
}

//LOGIN
$("body").on("click", "#button-login", e=> postLogin(getLoginInputData().username, getLoginInputData().password));
// mieter hinzufügen "Mieter anlegen" button
$("body").on("click", "#button-addMieter", e=> showMieterInputField());
$("body").on("click", "#btn-mieter-speichern", e=> getInputData());
$("body").on("click", "#btn-modal-speichern", e=> saveMieterAndConfirm());
// mieter bearbeiten
$("body").on("click", ".edit-tenant-button", e=> saveTargetId($(event.target).attr("item-id")));
$("body").on("click", "#btn-edit-tenant-speichern", e=> getEditedTenantData());
$("body").on("click", "#btn-modal-edit-tenant-confirm", e=> editMieter(itemId, fn, ln, adr, plz, city, mail, tel, mob));

// mieter Löschen
$("body").on("click", ".delete-mieter-button", e=> saveTargetId($(event.target).attr("item-id")));
$("body").on("click", "#btn-modal-Mieter-loeschen", e=> deleteItem(mieter, itemId));
// SB neue nachricht speichern
$("body").on("click", "#button-save-schwarzesBrettNachricht", e=> saveSchwarzesBrettEntry());
// SB Nachricht löschen
$("body").on("click", ".delete-SBItem-button", e=> saveTargetId($(event.target).attr("item-id")));
$("body").on("click", "#btn-modal-SBItem-loeschen", e=> deleteItem(schwarzesBrett, itemId));
$('.datepicker').pickadate({
	selectMonths: true, // Creates a dropdown to control month
   	selectYears: 15, // Creates a dropdown of 15 years to control year,
   	today: 'Today',
   	clear: 'Clear',
   	close: 'Ok',
  	closeOnSelect: false // Close upon selecting a date,
});
// forum neue nachricht speichern
$("body").on("click", "#button-save-forumNachricht", e=> saveForumEntry());

// AUTOCOMPLETE CITY ANHAND VON PLZ
$('#plz').bind('keyup change', function(e) {
    if ($(this).val().length > 4) {
        var ort = $('#ort');
        $.getJSON('http://www.geonames.org/postalCodeLookupJSON?&country=DE&callback=?', {postalcode: this.value }, function(response) {
            if (response && response.postalcodes.length && response.postalcodes[0].placeName) {
                ort.val(response.postalcodes[0].placeName);
            }
        })
    } else {
        $('#ort').val('');
    }
});

// NAVBAR

function updateNavBar() {
	$('.nav-list li').each(function() {
		$(this).removeClass('active');		
	});
	$('.list-item a').each(function() {
		$(this).addClass('clickable');
	})
}

// MIETER


// gets the Tenant data for the edit Tenant modal and puts it in the modal

function getTenantData() {
    const id = $(event.target).attr("item-id");
    getItem(mieter, id, function (data) {
        $('#modal-edit-tenant-fn').text(data.firstName);
        $('#modal-edit-tenant-ln').text(data.lastName);
        $('#modal-edit-tenant-adr').text(data.adress);
        $('#modal-edit-tenant-plz').text(data.plz);
        $('#modal-edit-tenant-plz').text(data.city);
        $('#modal-edit-tenant-mail').text(data.mail);
        $('#modal-edit-tenant-mobil').text(data.mobil);
        $('#modal-edit-tenant-telpriv').text(data.tel);
    });
}

function loadMieter() {
	updateNavBar();
	clearBeforeLoad();
	addActionButton("addMieter");
	addRowForDynamicContent();
	loadAllItems(mieter);
}

function loadSB() {
	updateNavBar();
	clearBeforeLoad();
	addActionButton("addSB");
	addRowForDynamicContent();
	loadAllItems(schwarzesBrett);
}

function loadForum() {
    updateNavBar();
    $('#btn-forum-load').parents().addClass('active');
    clearBeforeLoad();
    addActionButton("addForum");
    addForumCategoryNavigation();
    addRowForDynamicContent();
    //loadAllItems(forum);
}

function loadAllItems(itemCategorie) {
	if (itemCategorie === mieter) {
		getItems(itemCategorie, items => items.forEach(item => addMieterToList(item)));
	}
	else if (itemCategorie === schwarzesBrett) {
		getItems(itemCategorie, items => items.forEach(item => addSBToList(item)));
	}
    else if (itemCategorie === forum) {
        getItems(itemCategorie, items => items.forEach(item => addForumToList(item)));
    }
}

function clearBeforeLoad() {
    document.getElementById('dynamic-content-container-forum').innerHTML = '';
	var inputContainer = document.getElementById("input-container2");
	if (inputContainer.classList.contains("show")) {
		inputContainer.classList.remove("show");
	}
	var element = document.getElementById("item-list-row");
	element.parentNode.removeChild(element);
	document.getElementsByClassName('btn-floating btn-large red')[0].removeAttribute("id");
	var actionButton = document.getElementsByClassName('btn-floating btn-large red')[0];
	actionButton.removeAttribute("href");
	actionButton.classList.remove('modal-trigger');
	resetActionButtonSymbol();
	
}

function addActionButton(idValue) {
	var actionButton = document.getElementsByClassName('btn-floating btn-large red')[0];
	var href = "#modal-" + idValue;
	var idValue = "button-" + idValue;
	actionButton.setAttribute("id", idValue);
	if (idValue === 'button-addSB') {
		actionButton.setAttribute("href", href);
		actionButton.classList.add('modal-trigger');	
	}
}

function addRowForDynamicContent() {
	var dynContainer = document.getElementsByClassName('dynamic-content-container')[0];
	var row = document.createElement('div');
	row.className = 'row';
	row.setAttribute('id', 'item-list-row');
	dynContainer.appendChild(row);
}

function resetActionButtonSymbol() {	
	document.getElementById('action-button-symbol').textContent = "add";	
}

function changeActionButtonSymbol() {
	var container = document.getElementById('action-button-symbol');
	var symbol = document.getElementById('action-button-symbol').textContent;
	container.textContent = (symbol === "add") ? "remove" : "add";
}

function showMieterInputField() {	
	var mieterInputField = document.querySelector(".input-mieter2");
	mieterInputField.classList.toggle("show");
	changeActionButtonSymbol();	
}

// DYNAMISCHER INHALT MIETER
function addMieterToList(data) {

	const row = document.getElementById('item-list-row');

    const section = document.createElement("section");
	section.className = "item-card-container col s12 m6 l4";
	section.setAttribute("item-id", data.id);

    const card_blue = document.createElement("div");
	card_blue.className = "item-card card blue-grey darken-1";

    const card_content = document.createElement("div");
	card_content.className = "item-card-content white-text";

    const ul = document.createElement("ul");
	ul.className = "item-list";

    const li = document.createElement("li");
	li.className = "mieter-card-name";
	li.innerText = data.firstName + " " + data.lastName;
	ul.appendChild(li);

    const li2 = document.createElement("li");
	li2.className = "mieter-card-adr";
	li2.innerText = data.adress + ", " + data.plz + " " + data.city;
	ul.appendChild(li2);

    const li3 = document.createElement("li");
	li3.className = "mieter-card-mail";
	li3.innerText = data.mail;
	ul.appendChild(li3);

    const li4 = document.createElement("li");
	li4.className = "mieter-card-tel";
	li4.innerText = data.tel;
	ul.appendChild(li4);

    const li5 = document.createElement("li");
	li5.className = "mieter-card-mobil";
	li5.innerText = data.mobil;
	ul.appendChild(li5);

    const footer = document.createElement("div");
	footer.className = "card-action";

    var a1 = document.createElement("a");
    a1.className = "delete-mieter-button modal-trigger";
    a1.setAttribute("href", "#modal-mieterLoeschen");
    a1.setAttribute("item-id", data.id);
    a1.innerText = "Löschen";

    var a2 = document.createElement("a");
    a2.className = "edit-tenant-button modal-trigger";
    a2.setAttribute("href", "#modal-edit-tenant");
    a2.setAttribute('onClick', "getTenantData()");
    a2.setAttribute("item-id", data.id);
    a2.innerText = "Bearbeiten";

    var a3 = document.createElement("a");
    a3.className = "tenant-upload-button modal-trigger";
    a3.setAttribute("href", "#modal-tenant-upload");
    //a3.setAttribute('onClick', "getTenantData()");
    a3.setAttribute("item-id", data.id);
    a3.innerText = "Upload";

	footer.appendChild(a1);
	footer.appendChild(a2);

	card_content.appendChild(ul);
	card_blue.appendChild(card_content);
	card_blue.appendChild(footer);
	section.appendChild(card_blue);

	row.appendChild(section);
}

// DYNAMISCHER INHALT SCHWARZES BRETT

function addSBToList(data) {

	var row = document.getElementById('item-list-row');

	var section = document.createElement("section");
	section.className = "item-card-container col s12";
	section.setAttribute("item-id", data.id);

	var card_blue = document.createElement("div");
	card_blue.className = "SBItem-card card blue-grey darken-1";

	var card_content = document.createElement("div");
	card_content.className = "card-content SB white-text";
	card_content.setAttribute("id", "card-content-SB");

	var ul = document.createElement("ul");
	ul.className = "SB-list-content";

	var li = document.createElement("li");
	li.className = "SB-header";

	var span1 = document.createElement("span");
	span1.className = "SB-card-title";
	span1.innerText = data.titel;
	li.appendChild(span1);

	var span2 = document.createElement("span");
	span2.className = "SB-card-verfasser";
	span2.innerText = data.verfasser + ", am  " + data.erstellDatumFormated + " um " + data.erstellZeit;
	li.appendChild(span2);

	ul.appendChild(li);

	var li2 = document.createElement("li");
	li2.className = "SB-card-nachricht";
	li2.innerText = data.nachricht;
	ul.appendChild(li2);	

	var footer = document.createElement("div");
	footer.className = "card-action";

	var a1 = document.createElement("a");
	a1.className = "delete-SBItem-button modal-trigger";
	a1.setAttribute("href", "#modal-delete-SB");
	a1.setAttribute("item-id", data.id);
	a1.innerText = "Löschen";

	var a2 = document.createElement("a");
	a2.className = "edit-SBItem-button";
	a2.setAttribute("href", "#");
	a2.innerText = "Bearbeiten";

	footer.appendChild(a1);
	footer.appendChild(a2);

	card_content.appendChild(ul);
	card_blue.appendChild(card_content);
	card_blue.appendChild(footer);
	section.appendChild(card_blue);

	row.appendChild(section);
}

// DYNAMISCHER INHALT FORUM

function addForumCategoryNavigation() {
    const navBar = `<nav id="drawer" class="nav">
          <ul class="nav__list">
            <li class="nav__item"><a onclick=getForumItemsByCategory(sessionStorage.getItem(objectData).forumCategories[0].id)>News</a></li>
            <li class="nav__item"><a onclick=getForumItemsByCategory(sessionStorage.getItem(objectData).forumCategories[1].id)>Events</a></li>
            <li class="nav__item"><a onclick=getForumItemsByCategory(sessionStorage.getItem(objectData).forumCategories[2].id)>Culture</a></li>
            <li class="nav__item"><a onclick=getForumItemsByCategory(sessionStorage.getItem(objectData).forumCategories[3].id)>Blog</a></li>
          </ul>
        </nav>`
    document.getElementById('dynamic-content-container-forum').innerHTML = navBar;
}

function getSessionId() {
    if(typeof(Storage) !== "undefined") {
        return sessionStorage.getItem("sessionID");
    } else {
        return sessionID;
    }
}

$( document ).ready(function(){
	$(".button-collapse").sideNav();
	$('.modal').modal();
	loadAllItems(mieter);
	addActionButton("addMieter");	
});
