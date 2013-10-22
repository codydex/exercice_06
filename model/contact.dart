part of exercice_06;

class Contacts {

  var contacts = new Map();

  Contacts(contacts) {
    this.contacts = contacts;
  }

  notEmpty(Event e) {
    InputElement inel = e.currentTarget as InputElement;
    var input = inel.value;
   if (input == null || input.isEmpty) {
     lbl_error.text = "You must fill in the field ${inel.id}!";
     inel.focus();
   }
  }

  storeData(Event e) {
    print("storeData.in");
    Contact f = new Contact(name.value, email.value, phone.value);
    try {

      contacts[name.value] = f;
      window.alert("$name added");
    } on Exception catch(e) {
      window.alert("Data not stored: Local storage has been deactivated!");
    } catch(e) {
      window.alert(e.toString());
    }
    print(contacts.length);
    print("storeData.out");
  }

  display() {
    String l = "<table border=\"1\"><th>Name</th><th>Phone</th><th>Email</th></tr>";
    for (var k in contacts.keys) {
      contact = contacts[k];
      l = "${l} <tr><td>${contact.name}</td><td>${contact.phone}</td><td>${contact.email}</td></tr>";
    }
    l = "$l </table>";
    document.query('#liste').setInnerHtml("$l",
      validator: new NodeValidatorBuilder()
        ..allowHtml5()
      );
  }

  attach_event_handlers() {
    name.onInput.listen(readData);
    ButtonElement btn_other = query('#btn_other');
    btn_other.onClick.listen(clearData);
  }

  clearData(Event e) {
    name.value = "";
    phone.value = "";
    email.value = "";
    name.focus();
  }

  readData(Event e) {
    var key = "${name.value}";
    if (!contacts.containsKey(key)) {
      lbl_error.innerHtml = "Unknown name";
      btn_create.text = "Creat a new contact";
      return;
    }
    lbl_error.innerHtml = "";
    btn_create.text = "Update a contact";
    phone.value = contacts[key].phone;
    email.value = contacts[key].email;
  }

  removeData(Event e) {
    print("removeData.in");
    var key = "${name.value}";
    print(key);
    print(contacts[key]);
    if (!contacts.containsKey(key)) {
      window.alert("This contact does not exist");
      return;
    }
    try {
      print("try");
      print(contacts[key]);
      contacts.remove(key);

      window.alert("Contact $key is deleted");
    } catch(e) {
      print("Done");
      window.alert(e.toString());
    }
    print(contacts.length);
    print("removeData.out");
  }
}

class Contact {
  
   String name;
   String phone;
   String email;

   Contact(this.name, this.phone, this.email);

   String toString() => "Contact's $name ($phone, $email)";

   String toJson() {
     var acc = new Map<String, Object>();
    
     acc["name"] = name;
     acc["phone"] = phone;
     acc["email"] = email;
     var accs = JSON.encode(acc);
     return accs;
   }

   Contact.fromJson(Map json) {
     this.name = json["name"];
     this.phone = json["phone"];
     this.email = json["email"];
   }
}