import 'package:flutter/material.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/models/Crib.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddCribScreen extends StatefulWidget {
  const AddCribScreen({super.key});

  @override
  State<AddCribScreen> createState() => _AddCribScreenState();
}

class _AddCribScreenState extends State<AddCribScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextfieldTagsController<Access> _tagController = DynamicTagController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          "Add Crib",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _namecontroller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Color(0xFFDFDFDF), width: 2),
                ),
                labelText: 'Rename device',
                hintText: 'Type a name',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Grant access (email)',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFieldTags<Access>(
              textfieldTagsController: _tagController,
              letterCase: LetterCase.small,
              validator: (Access access) {
                if (access.user == auth.currentUser!.email) {
                  return 'You can\'t sign access to your own email since you\'re the owner';
                }
                return null;
              },
              inputFieldBuilder: (context, textFieldTagValues) {
                return Row(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
