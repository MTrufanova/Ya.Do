//
//  Data.swift
//  TheApp
//
//  Created by msc on 20.07.2021.
//

import SwiftUI

struct Human: Identifiable {
    var id = UUID()
    var name: String
    var date: String
    var imageName: String
}

struct HumanList {
   static let humans = [
        Human(name: "Михаил Федорович Романов", date: "1613-1645", imageName: "Романов1"),
        Human(name: "Алексей Михайлович Романов (Тишайший)", date: "1645-1676", imageName: "Романов2"),
        Human(name: "Федор Алексеевич Романов", date: "1676-1682", imageName: "Романов3"),
        Human(name: "Петр I Алексеевич Романов (Великий)", date: "1682-1725 (самостоятельно правил с 1689)", imageName: "Романов4"),
        Human(name: "Екатерина I", date: "1725-1727", imageName: "Романов5"),
        Human(name: "Петр II Алексеевич Романов", date: "1727-1730", imageName: "Романов6"),
        Human(name: "Анна Иоанновна Романова", date: "1730-1740", imageName: "Романов7"),
        Human(name: "Иван VI Антонович Романов", date: "1740-1741", imageName: "Романов8"),
        Human(name: "Елизавета I Петровна Романова", date: "1741-1761", imageName: "Романов9"),
        Human(name: "Петр III Федорович Романов", date: "1761-1762", imageName: "Романов10"),
        Human(name: "Екатерина II Алексеевна Романова", date: "1762-1796", imageName: "Романов11"),
        Human(name: "Павел I Петрович Романов", date: "1796-1801", imageName: "Романов12"),
        Human(name: "Александр I Павлович Романов", date: "1801-1825", imageName: "Романов13"),
        Human(name: "Николай I Павлович Романов", date: "1825-1855", imageName: "Романов14"),
        Human(name: "Александр II Николаевич Романов (Освободитель)", date: "1855-1881", imageName: "Романов15"),
        Human(name: "Александр III Александрович Романов (Царь-Миротворец)", date: "1881-1894", imageName: "Романов16"),
        Human(name: "Николай II Александрович Романов", date: "1894-1917", imageName: "Романов17"),
    ]
}

