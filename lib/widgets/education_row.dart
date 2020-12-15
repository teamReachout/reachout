import 'package:flutter/material.dart';
import 'package:reachout/models/education.dart';

class EducationRow extends StatefulWidget {
  final Education education;
  final double verticalBarSize = 2.0;

  const EducationRow({Key key, this.education}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EducationRowState();
  }
}

class EducationRowState extends State<EducationRow> {
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
                // child: Container(
                //   height: 30.0,
                //   width: widget.verticalBarSize,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: widget.experience.color,
                //   ),
                // ),
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.grey,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.education.title,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        widget.education.institute,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 6.0),
                    //   child:  Text(
                    //     widget.experience.description,
                    //     style: TextStyle(
                    //         fontSize: 12.0, textBaseline: TextBaseline.alphabetic),
                    //   ),
                    // )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 15.0),
                child: Text(
                  widget.education.date,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 2,
          indent: 45,
          endIndent: 45,
        ),
      ],
    );
  }
}
