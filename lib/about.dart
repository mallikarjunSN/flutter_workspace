import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/cool_color.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.red[800],
          centerTitle: true,
          elevation: 4.00,
          backgroundColor: CoolColor().getColor(0x753A88),
          title: Text("Dyslexia",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 12.0, right: 12.0),
                    child: Text(
                      "Dyslexia is a learning disorder that involves difficulty reading due to problems identifying speech sounds and learning "
                      " how they relate to letters and words (decoding). Also called reading disability, dyslexia affects areas of the brain that process language.\n"
                      "Between 5% and 20% of all people have dyslexia. According to the Department of Biotechnology, the incidence of dyslexia "
                      "in India is estimated at 10% and nearly 35 million children in the country are thought to have this learning disability.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )),
                Container(
                  child: new Center(child: Image.asset('assets/count.png')),
                ),
                Container(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 12.0, right: 12.0),
                    color: Colors.grey[50],
                    child: Text(
                      "People with dyslexia have normal intelligence and usually have normal vision. Most children with dyslexia can "
                      "succeed in school with tutoring or a specialized education program. Emotional support also plays an important role.\n"
                      "Though there's no cure for dyslexia, early assessment and intervention result in the best outcome. "
                      "Sometimes dyslexia goes undiagnosed for years and isn't recognized until adulthood, but it's never too late to seek help.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )),
                Container(
                  child: new Center(child: Image.asset('assets/dys.png')),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent[100]),
                  child: Text(
                    'Symptoms',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  child: Text(
                    "Signs of dyslexia can be difficult to recognize before your child enters school, but some early clues may indicate a problem. "
                    "Once your child reaches school age, your child's teacher may be the first to notice a problem. Severity varies, but the condition "
                    "often becomes apparent as a child starts learning to read.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Container(
                  child: Image.asset("assets/symp.png"),
                  alignment: Alignment.center,
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent[100]),
                  child: Text(
                    'Before school',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  // color: Colors.grey[50],
                  child: Text(
                    "Signs that a young child may be at risk of dyslexia include:\n"
                    "   • Late talking\n"
                    "   • Learning new words slowly\n"
                    "   • Problems forming words correctly, such as reversing sounds in words or confusing words that sound alike\n"
                    "   • Problems remembering or naming letters, numbers and colors\n"
                    "   • Difficulty learning nursery rhymes or playing rhyming games",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent[100]),
                  child: Text(
                    'School age',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  child: Text(
                    "Once your child is in school, dyslexia signs and symptoms may become more apparent, including:\n"
                    "   • Reading well below the expected level for age\n"
                    "   • Problems processing and understanding what he or she hears\n"
                    "   • Difficulty finding the right word or forming answers to questions\n"
                    "   • Problems remembering the sequence of things\n"
                    "   • Difficulty seeing (and occasionally hearing) similarities and differences in letters and words\n"
                    "   • Inability to sound out the pronunciation of an unfamiliar word\n"
                    "   • Difficulty spelling\n"
                    "   • Spending an unusually long time completing tasks that involve reading or writing\n"
                    "   • Avoiding activities that involve reading",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent[100]),
                  child: Text(
                    'Teens and adults',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  child: Text(
                    "Dyslexia signs in teens and adults are similar to those in children. Some common dyslexia signs and "
                    "symptoms in teens and adults include:\n"
                    "   • Difficulty reading, including reading aloud\n"
                    "   • Slow and labor-intensive reading and writing\n"
                    "   • Problems spelling\n"
                    "   • Avoiding activities that involve reading\n"
                    "   • Mispronouncing names or words, or problems retrieving words\n"
                    "   • Trouble understanding jokes or expressions that have a meaning not easily understood from the "
                    "specific words (idioms), such as piece of cake meaning easy\n"
                    "   • Spending an unusually long time completing tasks that involve reading or writing\n"
                    "   • Difficulty summarizing a story\n"
                    "   • Trouble learning a foreign language\n"
                    "   • Difficulty memorizing\n"
                    "   • Difficulty doing math problems",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent[100]),
                  child: Text(
                    'Causes and Risk factors',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  child: Text(
                    "Dyslexia tends to run in families. It appears to be linked to certain genes that affect how the "
                    "brain processes reading and language, as well as risk factors in the environment.\n"
                    "Dyslexia risk factors include:\n"
                    "   • A family history of dyslexia or other learning disabilities\n"
                    "   • Premature birth or low birth weight\n"
                    "   • Exposure during pregnancy to nicotine, drugs, alcohol or infection that may alter brain development in the fetus\n"
                    "   • Individual differences in the parts of the brain that enable reading",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Container(
                  child: Image.asset("assets/dys2.png"),
                  alignment: Alignment.center,
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent[100]),
                  child: Text(
                    'Complications',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  child: Text(
                    "Dyslexia can lead to a number of problems, including:\n"
                    "   • Trouble learning: Because reading is a skill basic to most other school subjects, "
                    "a child with dyslexia is at a disadvantage in most classes and may have trouble keeping up with peers.\n"
                    "   • Social problems: Left untreated, dyslexia may lead to low self-esteem, behavior problems, anxiety, "
                    "aggression, and withdrawal from friends, parents and teachers.\n"
                    "   • Problems as adults: The inability to read and comprehend can prevent a child from reaching his or "
                    " her potential as the child grows up. This can have long-term educational, social and economic consequences.\n"
                    "Children who have dyslexia are at increased risk of having attention-deficit/hyperactivity disorder (ADHD), "
                    "and vice versa. ADHD can cause difficulty sustaining attention as well as hyperactivity and impulsive "
                    "behavior, which can make dyslexia harder to treat.",
                    // textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.greenAccent[100]),
                  child: Text(
                    'Treatment',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 5.0, left: 12.0, right: 12.0),
                  child: Text(
                    "There's no known way to correct the underlying brain abnormality that causes dyslexia — "
                    "dyslexia is a lifelong problem. However, early detection and evaluation to determine specific needs "
                    "and appropriate treatment can improve success.\n"
                    "We developed one of the solution to assist Dyslexic people in learning to read and type more "
                    "accurately by providing them suitable assessments. It tracks improvement over the user time. "
                    "The average accuracy in the statistic section of the application gives an insight to the user "
                    "to decide on how much effort he/she has to put in the future to get better.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ]),
        ));
  }
}
