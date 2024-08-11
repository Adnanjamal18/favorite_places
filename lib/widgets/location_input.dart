import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _LocationInputState();
  }
}

class _LocationInputState extends State <LocationInput>{
 Location? _pickedLocation;
 var _isGettingLocation = false;

void _getCurrentLocation ()async{
  
  
  Location location = Location();

bool serviceEnabled;
PermissionStatus permissionGranted;
LocationData locationData;

serviceEnabled = await location.serviceEnabled();
if (!serviceEnabled) {
  serviceEnabled = await location.requestService();
  if (!serviceEnabled) {
    return;
  }  
}

permissionGranted = await location.hasPermission();
if (permissionGranted == PermissionStatus.denied) {
  permissionGranted = await location.requestPermission();
  if (permissionGranted != PermissionStatus.granted) {
    return;
  }
}
setState(() {
    _isGettingLocation = true;
  });

locationData = await location.getLocation();

setState(() {
    _isGettingLocation = false;
  });

}
@override
  Widget build(BuildContext context) {
    Widget previewContent = Text('no location chosen',textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: Theme.of(context).colorScheme.onBackground,
    ),);

    if (_isGettingLocation) {
      previewContent=const CircularProgressIndicator();
    }
    return Column(children: [
      Container(height: 170,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
      border: Border.all(width: 1,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
    ),
    child: previewContent,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [TextButton.icon(icon: const Icon(Icons.location_off_rounded),onPressed:_getCurrentLocation, label: Text('Get Current Location'),),
        TextButton.icon( icon: Icon(Icons.map_outlined),onPressed: (){}, label: Text('select on map') ,)
        ],
      )
      ],
      );
    
  }
}