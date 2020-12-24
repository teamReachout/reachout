import 'package:flutter/material.dart';
import 'package:reachout/models/opportunities.dart';
import 'package:reachout/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

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
      link:
          'https://hpair.org/',
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
      link:
          'https://esummit.in/',
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
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            autofocus: true,
            enabled: true,
            title: Text(
              o.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              o.description,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () => goToLink(o.link),
          ),
        ),
        Divider(
          thickness: 1,
          indent: 25,
          endIndent: 25,
          color: Colors.black,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Appbar(),
        preferredSize: const Size.fromHeight(44),
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
