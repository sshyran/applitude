---
title: iApplause
layout: default
---

[Source](https://github.com/ralfebert/iApplause/) |
[Issues](http://ralfebert.lighthouseapp.com/projects/67904-iapplause/tickets) |
[Downloads](#downloads)

# iApplause

iApplause is a runtime framework accompanied by a DSL for developing data-centric iPhone applications. It is an iPhone-only version of the [Applause](http://code.google.com/p/applause/) Xtext DSL, extended and very much customized to my own needs.

## Overview

iApplause provides a domain specific language to describe iPhone applications, esp. the boring parts which are manually coded over and over again, in a crisp and precise way. For example, this application loads data from a URL, parses a [JSON document](https://github.com/ralfebert/iApplause/blob/gh-pages/demo/devices.json) and shows it using generated `UITableViewController` classes:

![Screenshots iApplause demo application](demo.png)

This application can be generated from [`demo.applause`](https://github.com/ralfebert/iApplause/blob/master/examples/demo/demo.applause):

	application Demo {
		view:Tabs()
	}

	type String mapsTo "NSString"

	entity Speaker {
		String speaker
		String speakerUri
	}

	entity Presentation {
		String title
		Speaker[] speakers
	}

	contentprovider AllPresentations
		returns Presentation[]
		fetches JSON from "http://cfp.devoxx.com/rest/v1/events/1/presentations"
		selects ""

	tabview Tabs {
		tab {
			title: "Schedule"
			view: Schedule()
		}
	}

	tableview Schedule {
		Presentation[] allPresentations = AllPresentations()

		title: "Schedule"
		section {
			cell Default foreach allPresentations as presentation {
				text: presentation.title
				accessory: Link
				action: PresentationDetails(presentation)
			}
		}
	}

	tableview PresentationDetails(Presentation presentation) {
		title: presentation.title
		style: Grouped

		section {
			title:"Speakers"
			cell Default foreach presentation.speakers as speaker {
				text: speaker.speaker
			}
		}
	}

iApplause is based on the marvelous [Xtext language development framework](http://www.eclipse.org/Xtext/), and as such, it comes with an Eclipse IDE plug-in:

![iApplause demo application editor](demo_ide.png)

And there is a code generator which generates iPhone applications from such DSL documents. The generated code is kept small and tidied up by making use of runtime components wherever possible. Have a look at [examples/demo/Generated](https://github.com/ralfebert/iApplause/tree/master/examples/demo/Generated) to see the generated code for `demo.applause`.

## Words of warning

The project currently is very much work in progress and therefore not very well documented; you will find loose ends and corners. You'll only get something out of it if you're seriously into Xtext DSLs and iPhone development with Objective C.

## Getting started

* At first, learn about building DSLs with Xtext, for example by following the tutorial in the [Xtext Getting started documentation](http://www.eclipse.org/Xtext/documentation/).
* I wrote a tutorial for the original Applause project which shows [how to install everything and create a project from scratch](http://www.ralfebert.de/blog/xtext/applause_new_app/). Almost everything still holds true for iApplause.
* Import the example projects in Eclipse, inspect the `*.applause` documents, run the projects from Xcode, inspect the generated code.

## Example projects

### Demo

[`examples/demo/`](https://github.com/ralfebert/iApplause/tree/master/examples/demo) is a working example project demonstrating how to fetch JSON content via HTTP and how to show it using table views:

![Screenshots iApplause demo application](demo.png)

### TestApp, Running unit tests

[`examples/testapp/`](https://github.com/ralfebert/iApplause/tree/master/examples/testapp) is a reference application showing the language features (target testapp). It also contains a [GHUnit](https://github.com/gabriel/gh-unit/) test suite (target Tests):

![testapp Screenshots](testapp.png)




<a name="download"/>

## Downloads

You can download the project in either:

<div class="download">
  <a href="http://github.com/ralfebert/iApplause/zipball/master">
    <img border="0" width="90" src="http://github.com/images/modules/download/zip.png"></a>
  <a href="http://github.com/ralfebert/iApplause/tarball/master">
    <img border="0" width="90" src="http://github.com/images/modules/download/tar.png"></a>
</div>

You can also clone the project with [Git](http://git-scm.com) by running:

	$ git clone git://github.com/ralfebert/iApplause

Or get the source code on the [GitHub project page](http://github.com/ralfebert/iApplause)

## Licenses

[Eclipse Public License v1.0](http://www.eclipse.org/legal/epl-v10.html)

Some runtime components have other licenses:

* ASIHTTPRequest, TouchXML, Reachability, parts of NSDate+Utils: BSD license
* TouchJSON, GHUnit, TextFieldCell: MIT license
* TTGlobalNetwork, UIView+Coordinates, parts of URLUtils: Apache License
* UIImage+Alpha/Resize/RoundedCorner: Other licenses

This document is licensed under <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/80x15.png" /></a>