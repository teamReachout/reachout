import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reachout/models/opportunities.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reachout/widgets/search.dart';

class OpportunitiesScreen extends StatefulWidget {
  @override
  _OpportunitiesScreenState createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  List<Opportunities> opportunities = [
    Opportunities(
      name: 'ESUMMIT',
      description:
          'Wander around exploring the startup life around you and test your entrepreneurship knowledge.',
      link:
          'https://dare2compete.com/o/e-summit-e-summit-2021-kj-somaiya-institute-of-management-kj-sim-mumbai-141433',
    ),
    Opportunities(
      name: 'Rice Business Plan Competition',
      description:
          'The Rice Business Plan Competition is the world’s richest and largest graduate-level student startup competition.',
      link: 'https://rbpc.rice.edu/',
    ),
    Opportunities(
      name: 'HARVARD US INDIA INITIATIVE',
      description:
          'HUII, or the Harvard College US-India Initiative, is a student-run organization that aims to create a dialogue between Indian and American youth to address some of India’s most pressing social, economic, and environmental issues today.',
      link: 'https://huii.in/',
    ),
    Opportunities(
      name: 'Harvard College Project for Asian and International Relations',
      description:
          'Our mission is simple: we connect the top leaders of today and tomorrow in a dynamic forum of exchange.',
      link: 'https://hpair.org/',
    ),
    Opportunities(
      name: 'Meraki 2020- Unique Business Plan Competition',
      description:
          'Meraki – The B-Plan competition is designed to give collegiate entrepreneurs a real-world experience to fine-tune their business plans and elevator pitches to generate funding to successfully commercialize their product.',
      link:
          'https://dare2compete.com/o/meraki-2020-unique-business-plan-competition-fortune-institute-of-international-business-fiib-new-delhi-95368',
    ),
    Opportunities(
      name: 'ESUMMIT\'21 EMBRACING EVOLUTION',
      description:
          'E-Summit being the flagship event of ECell, is held annually brings together the academic community, venture capitalists, new age entrepreneurs and all those passionate about entrepreneurship to common grounds.',
      link: 'https://esummit.in/',
    ),
  ];

  goToLink(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget displayOpportunity(Opportunities o) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 0.5,
            child: ListTile(
              autofocus: true,
              enabled: true,
              title: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      o.name.toUpperCase(),
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      )
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  top: 2,
                  child: Icon(Icons.link_sharp, size: 20, color: Color(0xFF880E4F)),
                )
              ]),
              subtitle: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  o.description,
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  )
                ),
              ),
              onTap: () => goToLink(o.link),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
          centerTitle: true,
          toolbarOpacity: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: const Radius.circular(7),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.search,
              color: const Color.fromRGBO(244, 248, 245, 1),
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: Search(),
            ),
          ),
          primary: true,
          title: Text('opportunities'.toUpperCase(),
              style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromRGBO(244, 248, 245, 1),
                  letterSpacing: 1.2)),
        ),
        preferredSize: const Size.fromHeight(55),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              child: ListView(
                children: [
                  ...opportunities.map((o) {
                    return displayOpportunity(o);
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
