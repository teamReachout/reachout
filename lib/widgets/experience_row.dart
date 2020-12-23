import 'package:flutter/material.dart';
import 'package:reachout/models/experience.dart';
import 'package:google_fonts/google_fonts.dart';

class ExperienceRow extends StatefulWidget {
  final Experience experience;
  final double verticalBarSize = 2.0;

  const ExperienceRow({Key key, this.experience}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExperienceRowState();
  }
}

class ExperienceRowState extends State<ExperienceRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 32.0 - widget.verticalBarSize / 2),
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.black,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.experience.jobTitle.toUpperCase(),
                      style: GoogleFonts.roboto(fontSize: 17.0, color: Colors.black, letterSpacing: 0.7),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        widget.experience.company,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        widget.experience.description,
                        style: GoogleFonts.quicksand(
                            fontSize: 14.0,
                            textBaseline: TextBaseline.alphabetic),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 15.0),
                child: Text(
                  widget.experience.date,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 0.5,
          indent: 45,
          endIndent: 45,
          color: Colors.black87,
        ),
      ],
    );
  }
}
