//
//  Tenant.swift
//  SuperVarioWohnenServer
//
//  Created by Tobias on 17.11.17.
//

import Foundation
import Kitura

class TenantContext {
    func getTenant(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) -> Void {
        // Input auswerten
        
        // Datenbank anfrage
        
        // Repsonse senden
        response.send("[{\"firstName\":\"Max\",\"lastName\":\"Mustermann\",\"adress\":\"somethingstr. 12\",\"plz\":\"12345\",\"mail\":\"derp@derpedidu.de\",\"tel\":\"123344456\",\"mobil\":\"01457854554\",\"qrCodeData\":\"MaxMustermannsomethingstr. 12\",\"id\":2},{\"firstName\":\"Noch\",\"lastName\":\"Einanderer\",\"adress\":\"Derwohnthier 23\",\"plz\":\"64545\",\"mail\":\"spambitte@gmail.com\",\"tel\":\"454654\",\"mobil\":\"654654654654\",\"qrCodeData\":\"NochEinandererDerwohnthier 23\",\"id\":3},{\"firstName\":\"Last\",\"lastName\":\"Andleast\",\"adress\":\"Besterstrassenname 12\",\"plz\":\"12589\",\"mail\":\"adflkj@keinbockmehr.de\",\"tel\":\"\",\"mobil\":\"017589456855\",\"qrCodeData\":\"LastAndleastBesterstrassenname 12\",\"id\":4},{\"firstName\":\"Nochein\",\"lastName\":\"Versuch\",\"adress\":\"versuchsstr. 2\",\"plz\":\"12345\",\"mail\":\"kjh@difhg.com\",\"tel\":\"234786283\",\"mobil\":\"017645878956\",\"qrCodeData\":\"NocheinVersuchversuchsstr. 2\",\"id\":6},{\"firstName\":\"Stefan\",\"lastName\":\"Neuberger\",\"adress\":\"Hauptstraße 136\",\"plz\":\"10827\",\"mail\":\"stef.neuberger@gmail.com\",\"tel\":\"\",\"mobil\":\"017676023782\",\"qrCodeData\":\"StefanNeubergerHauptstraße 136\",\"id\":7}]")
        next()
    }
}
