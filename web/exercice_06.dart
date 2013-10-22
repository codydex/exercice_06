library exercice_06;

import 'dart:html';
import 'dart:convert';

part '../model/contact.dart';

InputElement name, phone, email;
InputElement pin_code;
LabelElement lbl_error, lbl_phone2, lbl_email2, lbl_repertoire;
ButtonElement btn_create, btn_remove, btn_other;
Contact contact;

void main() {
  bindElements();
  attach_event_handlers();
  display();
}

bindElements() {
  
  btn_create = query('#btn_create');
  btn_remove = query('#btn_remove');
  btn_other = query('#btn_other');

  
  name = query('#name');
  phone = query('#phone');
  email = query('#email');

  lbl_error = query('#error');
  lbl_error.text = "";
  lbl_error.style..color = "red";
  lbl_repertoire = query('#repertoire');
  lbl_repertoire.text = "";

}


initContacts(Event e) {
  for (String key in window.localStorage.keys) {
    window.localStorage.remove(key);
  }
  contact = new Contact("Luis Figo", "651-777-4545", "Louis_Figo@msn.pr");
  window.localStorage["Contact:Luis Figo"] = contact.toJson();
  contact = new Contact("David Beckham", "554-777-5656", "David_Beckham@hotmail.en");
  window.localStorage["Contact:David Beckham"] = contact.toJson();
  contact = new Contact("Cristiano Ronaldo", "555-777-9999", "Cristiano_Ronaldo@hotmail.pr");
  window.localStorage["Contact:Cristiano Ronaldo"] = contact.toJson();
  contact = new Contact("Raul Gonzales", "555-777-1010", "Raul_Gonzales@hotmail.es");
  window.localStorage["Contact:Raul Gonzales"] = contact.toJson();
  contact = new Contact("Gustav holst", "555-888-1902", "Gustav_holst@hotmail.fr");
  window.localStorage["Contact:Gustav holst"] = contact.toJson();
  display();
}

storeData(Event e) {
  Contact f = new Contact(name.value, phone.value, email.value); 
  
  if (name.value == "" || name.value.isEmpty ) {
    window.alert("No name was entered. The contact was not created.");
    return;
  }
  
  if (phone.value == "" || phone.value.isEmpty ) {
    window.alert("No phone was entered. The contact was not created.");
    return;
  }
  RegExp exp = new RegExp(r"[0-9]{3}-[0-9]{3}-[0-9]{4}");
  if (!exp.hasMatch(phone.value)) {
    window.alert("The phone number does not meet the required format(000-000-0000).");
    return;
  }
  if (email.value == "" || email.value.isEmpty ) {
    window.alert("No E-mail was entered. The contact was not created");
    return;
  }
  try {
    window.localStorage["Contact:${f.name}"] = f.toJson();
    window.alert("$f Added to the repertory");
  } on Exception catch(e) {
    window.alert("Unsaved contact: Local storage is disabled!");
  }
  catch(e) {
    window.alert(e.toString());
  }
}

attach_event_handlers() {
  name.onInput.listen(readData);

  ButtonElement btn_other = query('#btn_other');
  btn_other.onClick.listen(videFormulaire);

  ButtonElement btn_create = query('#btn_create');
  btn_create.onClick.listen(storeData);

  ButtonElement btn_remove = query('#btn_remove');
  btn_remove.onClick.listen(supprimeContact);

}

videFormulaire(Event e) {
  name.value = "";
  phone.value = "";
  email.value = "";
  name.focus();
}

readData(Event e) {
  var key = "Contact:${name.value}";
  if (!window.localStorage.containsKey(key)) {
    btn_create.text = "Creat a contact";
    return;
  }
  lbl_error.innerHtml = "";
  btn_create.text = "Update a contact";
  String acc_json = window.localStorage[key];
  contact = new Contact.fromJson(JSON.decode(acc_json));
  phone.value = "${contact.phone}";
  email.value = "${contact.email}";
}

display() {
  String affichage;
  if (window.localStorage.isEmpty) {
    lbl_repertoire.innerHtml = "the repertory is empty";
  } else {
    affichage = "<table border=1><th>Name</th><th>phone</th><th>email</th>";
    for (String key in window.localStorage.keys) {
        String acc_json = window.localStorage[key];
        Contact f = new Contact.fromJson(JSON.decode(acc_json));
        affichage += "<tr><td>${f.name}</td><td>${f.phone}</td><td>${f.email}</td></tr>";
    }
    affichage += "</table>";
    lbl_repertoire.innerHtml = affichage;
  }
}

supprimeContact(Event e) {
  String key = "Contact:${name.value}";
  if (!window.localStorage.containsKey(key)) {
    window.alert("This contact does not exist");
    return;
  }
  String acc_json = window.localStorage[key];
  Contact f = new Contact.fromJson(JSON.decode(acc_json));
  window.localStorage.remove(key);
  window.alert("$f is deleted.");
  display();
}
