[//]: # (formattig help from https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details)

<img src="images/logos.png" alt="drawing" width="100%"/>

<style>
details > summary {
  font-size: 2em;
}
.glossaryTables table {
  width: 60%;
}
</style>


### iTRAQI: injury Treatment & Rehabilitation Accessibility Queensland Index <img src='images/iTRAQI-hex.png' align="right" height="150" /></a>

This version is only for **moderate-to-severe traumatic brain injuries**.


### Suggested citation:

> Jamieson Trauma Institute, Retrieval Services Queensland and Queensland University of Technology, 2024. iTRAQI: injury Treatment & Rehabilitation Accessibility Queensland Index, version 2.0. Available from: https://access.healthequity.link/ Accessed [date]

## About

iTRAQI (injury Treatment and Rehabilitation Accessibility Queensland Index) allows users to explore the average travel times to acute care for moderate-to-severe traumatic brain injuries under ideal but realistic scenarios, as well as one-way driving time to public, in-patient rehabilitation facilities.

Users can:

- Predict travel time from any location in Queensland.
- Discover the routes taken to get to acute care for 441 specific locations
- Explore how travel times interact with remoteness and socioeconomic status for small regions through filtering.
- Download estimates by small regions for census year boundaries (2011, 2016 and 2021).
- Learn more through the interactive tour.

iTRAQI is a collaborative project involving the Jamieson Trauma Institute (JTI), Queensland University of Technology (QUT) and representatives from Queensland Ambulance Service (QAS) and Retrieval Services Queensland (RSQ), supported by the Australian Research Council through the ARC Centre of Excellence for Mathematical and Statistical Frontiers (ACEMS), QUT's Centre for Data Science, and the Emergency Medicine Foundation, with additional input from government, community members and clinicians.


<details>
  <summary>Using the site</summary>
  
  <h3>Map</h3>
  
  <img src="images/control_panel.png" alt="drawing" width="250"/> 
  Select layers from the list on the control panel.
  
  
  <img src="images/search_icon.png" alt="drawing" width="50"/>
  Click on this icon to search for locations through the search tool.
  
  
  <h3>Downloads</h3>
  
  Here you can download excel files that contain aggregated travel time to both acute and rehabilitation care separately, along with the iTRAQI index, for each statistical area level 1 and 2 (SA1 and SA2). They also include correspondence with the Socio-Economic Indexes for Areas (SEIFA) quintiles and the five remoteness areas (based on the Accessibility/Remoteness Index of Australia).

These are available for the 2011, 2016 and 2021 editions of the Australian Statistical Geography Standard (ASGS). See <https://maps.abs.gov.au/> to compare geographic boundaries under different editions. The interactive maps displayed in this site use the 2016 ASGS SA1 and SA2 boundaries.

If the download button downloads an html file initially, check that the tab you were previously on has loaded properly and then re-try.
  
</details>



<details>
  <summary>Methods</summary>
For 441 locations, travel time was calculated to acute care, and one-way driving time to rehabilitation units. These were interpolated using ordinary kriging to cover all of Queensland as a continuous measure. The median, maximum and minimum times were then calculated for the commonly used geographic boundaries of statistical areas 1 and statistical areas 2 (under the Australian Statistical Geography Standard). The maps display the 2016 ASGS boundaries, but downloads are also available for 2011 and 2021 boundaries.

<h3>Transport to rehabilitation</h3>
Based on driving times, calculated using ArcGIS Online, using established speed limits and road networks, and using ‘off-peak’ traffic conditions.

<h3>Transport to acute care</h3>
This was a mix of air and road retrievals, as would be considered in practice.

Road transport assumptions: 
<ol type="1">
<li> Patient assumed to have met the Queensland Ambulance Service, pre-hospital trauma by-pass guideline.
<li> One hour road transport boundaries calculated using off-peak and non-emergency driving conditions.
<li> Response to an acute incident location has the following assumptions:
   <ol type="a">
   <li>All locations include a 15-minute coordination time (irrespective of response organisation or platform). This accounts for:
       <ol type="1">
       <li> National Triple Zero (000) call routing to the ambulance service in Queensland;
       <li> Time for an Emergency Medical Dispatcher to answer the call;
       <li> Triple Zero (000) call-taking procedure and/or RSQ coordination;
       <li> Dispatch of primary ambulance or aeromedical platform (i.e. notification of responding platform/service);
       <li> Time for health professionals to respond (i.e. receive an alert, walk to the ambulance/platform, set up navigation, etc.); and
       <li> Up to 10 minutes of road travel time.
       </ol> 
   <li> Where ArcGIS Pro calculated an ambulance road transport time of greater than 10 minutes, the additional travel (beyond 10 minutes) time was included (i.e. if the total travel time to an incident was 15 minutes, 5 minutes travel time was added to point 3.a).
   </ol>
   <li>Transport destination assumptions:
       <ol type="a">
       <li> Directly transport to a major trauma service (also referred to as a ‘neurosurgical centre’ in the case of moderate-severe TBI) if road transport time is within 60 minutes.
       <li> If greater than 60 minutes road transport time to a major trauma service, transport to the highest-level regional trauma service if within 60 minutes.
       <li> If greater than 60 minutes road transport from a major or regional trauma service, transport to the closest hospital. In the event this occurs, immediately notify Retrieval Services Queensland.
       </ol>
<li> Every road ambulance response was assigned 20 minutes of time on-scene for paramedics to assess, manage and extricate the patient.
<li> Limited consideration given to pre-hospital and aeromedical expertise where the incident occurred at the one-hour road drive time boundary of a major or regional trauma service.
<li> Road transport time was included only if the initial destination was a regional or major trauma service.
</ol>

Aeromedical transport assumptions:
<ol type="1">
<li> An aeromedical response (fixed wing, rotary wing, or a combination) is available at the closest home base, with no duty hours or weather restrictions, based on current aircraft locations and types.
<li> Transport as rapidly as possible to either Brisbane, Gold Coast or Townsville airports for fixed wing responses, or PAH, RBWH, GCUH or TUH for rotary wing responses.
    <ol type="a">
    <li> The in-flight time for each aeromedical leg was provided by RFDS or the RSQ Rotary Advisor, based on aircraft type at each base and calculated times based on direct flight paths
    </ol>
<li>Standardised response times were estimated by one of the investigators (CG) and validated by consensus opinion from other senior medical staff at RSQ. These included:
    <ol type="a">
    <li> Coordination and tasking by RSQ (see 3a above under ‘Road transport assumptions)
    <li> Response times by aeromedical teams [rotary wing (15 minutes) and fixed wing (60 minutes)]
    <li> Standardised on-scene times [rotary wing (60 minutes) and fixed wing (120 minutes)]
    <li> Where a patient was initially transported to a regional trauma service, 120 minutes was added to the patient journey. This time allows for initial triage, assessment and management of the patient at the regional trauma service prior to transport to a major trauma service
    </ol>
<li> No restrictions to destination facilities, such as access block.
</ol>

<h3>Limitations</h3>
Specific assumptions were made which may not be met in certain circumstances:

<ol type="1">
<li> Suitable aircraft are considered available for deployment and appropriately staffed at the nearest RSQ location.
<li> Ambulances are considered to drive at the posted speed limit. 
<li> Standard times for emergency response coordination and deployment were applied, but these may vary.
<li> Isochrones could have given better driving times than interpolating from specific points, but ArcGIS only allowed these to be calculated up to 5 hours driving time, which was too short for our needs.
</ol>
  
  <b>Full details available in the [technical report](https://eprints.qut.edu.au/235026/).</b>
</details>



### List of abbreviations

<div class="glossaryTables">

|  |      
|-|:-----------|
| PAH   | Princess Alexandra Hospital               |
| RBWH  | Royal Brisbane and Women's Hospital       |
| QAS   | Queensland Ambulance Service              |
| SEIFA | Socio-Economic Indexes for Areas          |
| ASGS  | Australian Statistical Geography Standard |
| SA1   | Statistical Areas level 1                 |
| SA2   | Statistical Areas level 2                 |

</div>

### List of symbols

<div class="glossaryTables">

|  |      
|-|:-------------|
| <img src="images/town-marker.png" width="25"/>  | Town locations used for analyses (n=441)                       |
| <img src="images/acute-centre.png" width="25"/>   | Acute care centres (n=4)                                       |
| <img src="images/rehab-centre.png" width="25"/>   | Rehabilitation care centres (n=5)                              |
| <img src="images/rsq.png" width="25"/>          | Aeromedical locations (n=13)                                       |
| <img src="images/qas.png" width="25"/>    | Queensland Ambulance Service (QAS) locations (n=302)           |


</div>

## Resources

[Technical report](https://eprints.qut.edu.au/235026/) for full details on methods.

[Interactive maps ebook](https://rwparsons.github.io/interactive-maps/) for details on developing the app using R and Shiny.


### Contact us
If you have additional questions about iTRAQI, contact us through the webform at: https://healthequity.link/contact/ 


