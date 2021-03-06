/*
 * Copyright (c) 2020 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import Foundation

class NSMoreTestInformationPopupViewController: NSPopupViewController {
    init() {
        super.init(showCloseButton: true,
                   dismissable: true,
                   stackViewInset: .init(top: NSPadding.large, left: NSPadding.large, bottom: NSPadding.large, right: NSPadding.large))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tintColor = .ns_purple

        let subtitleText = "symptom_detail_box_subtitle".ub_localized
        let subtitleLabel = NSLabel(.textBold, textColor: .ns_purple)
        subtitleLabel.text = subtitleText
        subtitleLabel.accessibilityLabel = subtitleText.deleteSuffix("...")

        stackView.addArrangedSubview(subtitleLabel)
        stackView.addSpacerView(NSPadding.small)

        let titleText = "test_location_popup_title".ub_localized
        let titleLabel = NSLabel(.title)
        titleLabel.text = titleText
        stackView.addArrangedSubview(titleLabel)
        stackView.addSpacerView(NSPadding.large)

        let textLabel = NSLabel(.textLight)
        textLabel.text = "test_location_popup_text".ub_localized
        stackView.addArrangedSubview(textLabel)
        stackView.addSpacerView(NSPadding.large)

        let testLocations = ConfigManager.currentConfig?.testLocations ?? .defaultLocations

        for (index, location) in testLocations.locations.enumerated() {
            let externalLinkButton = NSExternalLinkButton(style: .normal(color: .ns_purple), size: .normal, linkType: .url)
            externalLinkButton.title = location.name.ub_localized
            externalLinkButton.touchUpCallback = { [weak self] in
                self?.openUrl(location.url)
            }
            stackView.addArrangedSubview(externalLinkButton)
            if index != (testLocations.locations.count - 1) {
                stackView.addSpacerView(NSPadding.medium)
            }
        }
    }

    private func openUrl(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension ConfigResponseBody.TestLocations {
    static var defaultLocations: Self {
        let json = """
        {
           "canton_aargau": "https://www.ag.ch/de/themen_1/coronavirus_2/coronavirus.jsp",
           "canton_appenzell_ausserrhoden": "https://www.ar.ch/verwaltung/departement-gesundheit-und-soziales/amt-fuer-gesundheit/informationsseite-coronavirus/",
           "canton_appenzell_innerrhoden": "https://www.ai.ch/themen/gesundheit-alter-und-soziales/gesundheitsfoerderung-und-praevention/uebertragbare-krankheiten/coronavirus",
           "canton_basel_country": "https://www.baselland.ch/politik-und-behorden/direktionen/volkswirtschafts-und-gesundheitsdirektion/amt-fur-gesundheit/medizinische-dienste/kantonsarztlicher-dienst/aktuelles",
           "canton_basel_city": "https://www.coronavirus.bs.ch/",
           "canton_berne": "http://www.be.ch/corona",
           "canton_fribourg": "https://www.fr.ch/de/gesundheit/covid-19/coronavirus-aktuelle-informationen",
           "canton_geneva": "https://www.ge.ch/covid-19-se-proteger-prevenir-nouvelle-vague",
           "canton_glarus": "https://www.gl.ch/verwaltung/finanzen-und-gesundheit/gesundheit/coronavirus.html/4817",
           "canton_graubuenden": "https://www.gr.ch/DE/institutionen/verwaltung/djsg/ga/coronavirus/info/Seiten/Start.aspx",
           "canton_jura": "https://www.jura.ch/fr/Autorites/Coronavirus/Accueil/Coronavirus-Informations-officielles-a-la-population-jurassienne.html",
           "canton_lucerne": "https://gesundheit.lu.ch/themen/Humanmedizin/Infektionskrankheiten/Coronavirus",
           "canton_neuchatel": "https://www.ne.ch/autorites/DFS/SCSP/medecin-cantonal/maladies-vaccinations/Pages/Coronavirus.aspx",
           "canton_nidwalden": "https://www.nw.ch/gesundheitsamtdienste/6044",
           "canton_obwalden": "https://www.ow.ch/de/verwaltung/dienstleistungen/?dienst_id=5962",
           "canton_st_gallen": "https://www.sg.ch/tools/informationen-coronavirus.html",
           "canton_schaffhausen": "https://sh.ch/CMS/Webseite/Kanton-Schaffhausen/Beh-rde/Verwaltung/Departement-des-Innern/Gesundheitsamt-2954701-DE.html",
           "canton_schwyz": "https://www.sz.ch/behoerden/information-medien/medienmitteilungen/coronavirus.html/72-416-412-1379-6948",
           "canton_solothurn": "https://corona.so.ch/",
           "canton_thurgovia": "https://www.tg.ch/news/fachdossier-coronavirus.html/10552",
           "canton_ticino": "https://www4.ti.ch/dss/dsp/covid19/home/",
           "canton_uri": "https://www.ur.ch/themen/2962",
           "canton_valais": "https://www.vs.ch/de/web/coronavirus",
           "canton_vaud": "https://www.vd.ch/toutes-les-actualites/hotline-et-informations-sur-le-coronavirus/",
           "canton_zug": "https://www.zg.ch/behoerden/gesundheitsdirektion/amt-fuer-gesundheit/corona",
           "canton_zurich": "https://www.zh.ch/de/gesundheit/coronavirus.html",
           "country_liechtenstein": "https://www.llv.li/inhalt/118724/amtsstellen/coronavirus"
        }
        """
        if let object = try? JSONDecoder().decode(Self.self, from: json.data(using: .utf8)!) {
            return object
        } else {
            fatalError()
        }
    }
}
