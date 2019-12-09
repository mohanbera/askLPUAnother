<!DOCTYPE html>
<html id="html1" lang="en">
<head>
  <meta charset="UTF-8">
  <title>Title</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.css"/>
  <link rel="stylesheet" href="/myStyle"/>
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/@mdi/font@4.x/css/materialdesignicons.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.min.css" rel="stylesheet">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/1.11.8/semantic.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.19.0/axios.min.js"></script>

  <script type="text/javascript">
    $(document).ready(function(){

      var signIn=true;
      var signUp=false;


      $('.ui.dropdown')
        .dropdown();
    });
  </script>
</head>
<body>

<div id="app">
  <v-app>
    <div elevation=10>
      <v-app-bar
        v-bind:color="colorName"
        dense
        dark
      >
        <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>

        <v-toolbar-title>AskLPU</v-toolbar-title>

        <v-spacer></v-spacer>


        <v-menu
          left
          bottom
        >
          <template v-slot:activator="{ on }">
            <v-btn icon v-on="on">
              <v-icon>color_lens</v-icon>
            </v-btn>
          </template>

          <v-list>
            <v-list-item
              v-for="data in colorCombo"
              :key="data.name"
              @click="changeColor(data.color)"
            >
              <v-list-item-title>{{ data.name }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>


        <template>
          <div class="text-center">
            <v-menu transition="scale-transition" min-width="300px">
              <template v-slot:activator="{ on }">
                <v-btn icon dark
                       v-on="on" v-on:click="showNotification">
                  <v-icon>notification_important</v-icon>
                </v-btn>
              </template>
              <v-list v-if="!notificationListFull">
                <v-list-item>
                  <v-list-item-title>No Notification for you</v-list-item-title>
                </v-list-item>
              </v-list>

              <v-list v-if="notificationListFull">
                <template v-for="list in notificationList">
                  <v-list-item>
                    <v-list-item-content>
                      <v-list-item-title class="teal--text">{{list.senderName}} <span class="pl-5"> {{list.date}}</span></v-list-item-title>
                      <p class="font-regular grey--text text--darken-2">{{list.notification}}</p>
                    </v-list-item-content>
                  </v-list-item>
                  <v-divider></v-divider>
                </template>
              </v-list>
            </v-menu>
          </div>
        </template>


        <v-btn icon  v-on:click="showLeaderBoard(num1)">
          <v-icon>mdi-magnify</v-icon>
        </v-btn>
        <template>
          <div class="text-center">
            <v-menu max-width="600px" transition="scale-transition" min-width="300px" offset-x offset-y class="teal" origin="center center">
              <template v-slot:activator="{ on }">
                <v-btn icon dark
                       v-on="on" v-on:click="showMessages">
                  <v-icon>message</v-icon>
                </v-btn>
              </template>
              <v-list v-if="!messageListFull">
                <v-list-item>
                  <v-list-item-title>No Message for you</v-list-item-title>
                </v-list-item>
              </v-list>
              <v-list v-if="messageListFull" class="multiline">
                <template v-for="list in messageList">
                <v-list-item>
                  <v-list-item-avatar>
                    <v-img v-bind:src="list.senderPic"></v-img>
                  </v-list-item-avatar>
                    <v-list-item-content>
                        <v-list-item-title class="teal--text">{{list.senderName}} <span class="pl-5"> {{list.date}}</span></v-list-item-title>
                      <p class="font-regular grey--text text--darken-2">{{list.message}}</p>
                    </v-list-item-content>
                </v-list-item>
                </template>
              </v-list>
            </v-menu>
          </div>
        </template>
      </v-app-bar>
    </div>


    <v-sheet
      height="100%"
      class="overflow-hidden"
      style="position: relative;"

    >
      <v-container class="fill-height">
        <v-row
          align="center"
          justify="center"
        >

        </v-row>
      </v-container>

      <v-navigation-drawer
        v-model="drawer"
        absolute
        temporary
        v-bind:color="colorName"
        dense
        dark
        v-bind:width="sliderWidth"
      >
        <v-list-item>
          <v-row class="justify-center">
            <v-list-item-avatar size="20%">
              <v-img class="elevation-15" style="border: " v-bind:src="profilePic"></v-img>
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-title><p class="title">{{profileName}}</p></v-list-item-title>
            </v-list-item-content>
        </v-list-item>
        </v-row>
        <p></p>

        <v-divider></v-divider>

        <v-list dense>

          <v-row justify="center">
            <v-dialog v-model="dialog" fullscreen hide-overlay transition="dialog-bottom-transition">
              <template v-slot:activator="{ on }">
                <v-list-item link >
                  <v-btn
                    v-bind:color="colorName"
                    dense
                    dark width="100%" height="50px" v-on="on" v-on:click="showProfile(profileReg)">Profile</v-btn>
                </v-list-item>
              </template>
              <v-card>
                <v-toolbar v-bind:color="colorName">
                  <v-btn icon dark @click="dialog = false">
                    <v-icon>mdi-close</v-icon>
                  </v-btn>
                  <v-toolbar-title class="white--text">Profile </v-toolbar-title>
                  <v-spacer></v-spacer>
                  <v-toolbar-items>


                    <template>
                      <div class="text-center">
                        <v-menu v-if="profile.admin" transition="scale-transition" :close-on-content-click="false" v-bind:min-width="allMailMinWidth" origin="center center">
                          <template v-slot:activator="{ on }">
                            <v-btn icon dark class="mt-2"
                                   v-on="on" v-on:click="showOutQuestions">
                              <v-icon>question_answer</v-icon>
                            </v-btn>
                          </template>

                          <v-list>
                            <template v-for="(list, index) in outQuestions">
                              <v-list-item>
                                <v-list-item-content>
                                  <v-list-item-title class="teal--text"><v-icon size="20">person_pin</v-icon> {{list.name}} <span class="pl-5">{{list.date}}</span></v-list-item-title>
                                  <p class="font-regular grey--text text--darken-2"><v-icon size="20">edit</v-icon> {{list.query}}</p>
                                  <v-list-item-title class="teal--text"><v-icon size="20">call</v-icon> {{list.mobileNumber}}<v-spacer></v-spacer> <v-icon size="20">email</v-icon> {{list.email}} <v-spacer></v-spacer>
                                    <div class="d-flex flex-row-reverse">
                                      <v-btn small color="red lighten-1 elevation-12 mr-3" dark v-on:click="deleteQuesAction(index)">
                                        <v-icon dark>delete</v-icon>
                                      </v-btn>

                                      <v-btn small class="mr-5 elevation-12" color="light-blue darken-1" dark v-on:click="showMenuForMail(list.email)">
                                        <v-icon dark >send</v-icon>
                                      </v-btn>
                                    </div>
                                  </v-list-item-title>
                                </v-list-item-content>
                              </v-list-item>
                              <v-divider></v-divider>
                            </template>
                          </v-list>

                          <template>
                            <v-row justify="center">
                              <v-dialog v-model="menuForOutMail" scrollable v-bind:max-width="mailMinWidth" persistent>

                                <v-card>
                                  <v-list>
                                    <v-spacer></v-spacer>
                                    <v-list-item>
                                      <v-list-item-avatar>
                                        <img v-bind:src="profilePic">
                                      </v-list-item-avatar>

                                      <v-list-item-content>
                                        <v-list-item-title>{{profileName}}</v-list-item-title>
                                      </v-list-item-content>

                                    </v-list-item>
                                  </v-list>


                                  <v-textarea
                                    v-bind:placeholder="mailPlaceholder"
                                    size="350"
                                    solo
                                    rounded
                                    v-model="mailMessage"
                                    elevation="10"
                                  ></v-textarea>

                                  <v-card-actions>
                                    <v-spacer></v-spacer>

                                    <v-btn text @click="menuForOutMail = false">Cancel</v-btn>
                                    <v-btn color="primary" text @click="menuForOutMail = false" v-on:click="sendMail">Send</v-btn>
                                  </v-card-actions>
                                </v-card>

                              </v-dialog>
                            </v-row>
                          </template>

                        </v-menu>
                      </div>
                    </template>

                    <template>
                      <v-menu
                        v-model="menu"
                        :close-on-content-click="false"
                        :nudge-width="400"
                        offset-x
                        v-if="profile.admin"
                      >
                        <template v-slot:activator="{ on }">
                          <v-btn
                            class="white--text"
                            v-on="on"
                            text
                          >
                            Send Notification
                          </v-btn>
                        </template>

                        <v-card>
                          <v-list>
                            <v-spacer></v-spacer>
                            <v-list-item>
                              <v-list-item-avatar>
                                <img v-bind:src="profilePic">
                              </v-list-item-avatar>

                              <v-list-item-content>
                                <v-list-item-title>{{profileName}}</v-list-item-title>
                              </v-list-item-content>

                            </v-list-item>
                          </v-list>
                          <v-textarea
                            placeholder="Write your notification message here..."
                            size="350"
                            solo
                            rounded
                            v-model="notificationMessage"
                          ></v-textarea>

                          <v-row>
                          <v-spacer></v-spacer>
                          <v-col cols="12" sm="6" md="10">
                            <v-text-field
                              v-if="!switch1"
                              placeholder="Write the registration numbers, separated by space..."
                              solo
                              rounded
                              height="80"
                              v-model="notificationRegNo"
                            ></v-text-field>
                          </v-col>
                          </v-row>
                          <v-card-actions>
                            <span>SEND TO ALL</span>
                            <v-row>
                            <v-switch v-model="switch1" class="ml-8"></v-switch>
                            </v-row>
                            <v-spacer></v-spacer>

                            <v-btn text @click="menu = false">Cancel</v-btn>
                            <v-btn color="primary" text @click="menu = false" v-on:click="sendNotification">Send</v-btn>
                          </v-card-actions>
                        </v-card>
                      </v-menu>
                    </template>

                    <template>
                      <v-btn
                        text
                        v-if="profileOwner"
                        dark
                        @click.stop="dialogForEditor = true"
                        v-on:click="saveEditor"
                      >
                        Edit
                      </v-btn>
                      <v-dialog
                        v-model="dialogForEditor"
                        max-width="800"
                        persistent
                      >
                        <v-card>
                          <v-card-title class="headline">Edit</v-card-title>

                          <v-card-text>
                            Profile
                          </v-card-text>

                          <template>
                            <v-row justify="start" align="start">
                              <v-col cols="12" sm="6" md="3">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Your full name"
                                  v-model="profileEdit.name"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-col cols="12" sm="6" md="4">
                                <v-text-field
                                  label="Solo"
                                  placeholder="College Name"
                                  v-model="profileEdit.college"
                                  solo
                                ></v-text-field>
                              </v-col>
                            </v-row>
                            <v-row justify="center" align="center">
                              <v-col cols="12" sm="6" md="2">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Degree"
                                  v-model="profileEdit.degree"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-col cols="12" sm="6" md="3">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Branch Name"
                                  v-model="profileEdit.branch"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-row>
                          </template>

                          <v-card-text>
                            Education
                          </v-card-text>
                          <v-spacer></v-spacer>
                          <template v-for="edu in educationEdit">
                            <v-row justify="center" align="center">
                              <v-col cols="12" sm="6" md="2">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Standard"
                                  v-model="edu.std"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-col cols="12" sm="6" md="5">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Institution Name"
                                  single-line
                                  v-model="edu.name"
                                  solo
                                ></v-text-field>
                              </v-col>

                              <v-col cols="12" sm="6" md="2">
                                <v-text-field
                                  label="Solo"
                                  placeholder="score"
                                  v-model="edu.marks"
                                  single-line
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-row>
                          </template>

                          <v-card-text>
                            Skills
                          </v-card-text>

                          <template v-for="skill in skillsEdit">
                            <v-row justify="center" align="center">
                              <v-col cols="12" sm="6" md="6">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Skill name"
                                  v-model="skill.name"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-col cols="12" sm="6" md="2">
                                <v-text-field
                                  label="Solo"
                                  placeholder="rating"
                                  single-line
                                  v-model="skill.rating"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-row>
                          </template>

                          <v-card-text>
                            Projects
                          </v-card-text>

                          <template v-for="project in projectsEdit">
                            <v-row justify="center" align="center">
                              <v-col cols="12" sm="6" md="5">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Project Name"
                                  v-model="project.name"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-col cols="12" sm="6" md="5">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Project link"
                                  single-line
                                  v-model="project.link"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-row>
                          </template>

                          <v-card-text>
                            Achievements
                          </v-card-text>

                          <template v-for="achievement in achievementsEdit">
                            <v-row justify="center" align="center">
                              <v-col cols="12" sm="6" md="5">
                                <v-text-field
                                  label="Solo"
                                  placeholder="Achievement Name"
                                  v-model="achievement.name"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-col cols="12" sm="6" md="5">
                                <v-text-field
                                  label="Solo"
                                  placeholder="link"
                                  single-line
                                  v-model="achievement.link"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-row>
                          </template>

                          <v-card-text>
                            Online Platforms
                          </v-card-text>

                          <template v-for="platform in platformsEdit">
                            <v-row justify="center" align="center">
                              <v-col cols="12" sm="6" md="3">
                                <v-text-field
                                  label="Solo"
                                  v-model="platform.name"
                                  solo
                                  readonly
                                ></v-text-field>
                              </v-col>
                              <v-col cols="12" sm="6" md="5">
                                <v-text-field
                                  label="Solo"
                                  placeholder="link"
                                  single-line
                                  v-model="platform.profileLink"
                                  solo
                                ></v-text-field>
                              </v-col>
                              <v-row>
                          </template>


                          <v-card-actions>
                            <v-spacer></v-spacer>

                            <v-btn
                              color="green darken-1"
                              text
                              @click="dialogForEditor = false"
                              v-on:click="saveEditorData"
                            >
                              Save
                            </v-btn>

                            <v-btn
                              color="green darken-1"
                              text
                              @click="dialogForEditor = false"
                              v-on:click="cancelEditorData"
                            >
                              Cancel
                            </v-btn>
                          </v-card-actions>
                        </v-card>
                      </v-dialog>
          </v-row>
          </template>
                  </v-toolbar-items>
                </v-toolbar>


          <!--------------all profile ---------------->
          <v-row>
            <v-col>
                <template>
                  <v-card
                    class="mt-2 mb-4 pa-2 ml-2 mr-10"
                  >
                    <v-card-title>
                    </v-card-title>

                    <v-card-actions>
                      <v-row
                        justify="center"
                        align="center"
                      >

                        <v-list-item class="grow">
                          <v-btn
                            class="teal--text"
                            v-on="on"
                            text
                            v-if="!profileOwner"
                          >
                            {{space}}Friends
                          </v-btn>
                          <v-spacer></v-spacer>
                          <v-list-item-avatar size="150px" color="teal lighten-1">
                            <v-img
                              class="elevation-6"
                              v-bind:src="profile.image"
                            ></v-img>
                          </v-list-item-avatar>
                          <v-spacer></v-spacer>
                          <template>
                              <v-menu
                                v-model="menu"
                                :close-on-content-click="false"
                                :nudge-width="400"
                                offset-x
                                v-if="!profileOwner"
                              >
                                <template v-slot:activator="{ on }">
                                  <v-btn
                                    class="teal--text"
                                    v-on="on"
                                    text
                                  >
                                    Message
                                  </v-btn>
                                </template>

                                <v-card>
                                  <v-list>
                                    <v-spacer></v-spacer>
                                    <v-list-item>
                                      <v-list-item-avatar>
                                        <img v-bind:src="profilePic">
                                      </v-list-item-avatar>

                                      <v-list-item-content>
                                        <v-list-item-title>{{profileName}}</v-list-item-title>
                                      </v-list-item-content>

                                    </v-list-item>
                                  </v-list>


                                  <v-textarea
                                    placeholder="Write your message here..."
                                    size="350"
                                    solo
                                    rounded
                                    v-model="message"
                                  ></v-textarea>

                                  <v-card-actions>
                                    <v-spacer></v-spacer>

                                    <v-btn text @click="menu = false">Cancel</v-btn>
                                    <v-btn color="primary" text @click="menu = false" v-on:click="messageSendAction">Send</v-btn>
                                  </v-card-actions>
                                </v-card>
                              </v-menu>
                          </template>
                      </v-row>
                      </v-list-item>
                    </v-card-actions>

                    <p class="headline text-center">
                      {{profile.name}}
                    <p class="text-sm text-center">{{profile.college}}
                      <br>{{profile.degree}}, {{profile.branch}}, {{profile.year}} Year</p>

                    </p>
                  </v-card>
                </template>

                <! --------------------- Education ------------------>

                <v-spacer></v-spacer>
                <template>
                  <v-card
                    class="mt-2 mb-2 ml-2 mr-10"
                  >
                    <v-card-title>
                      Education
                    </v-card-title>
                    <v-divider></v-divider>

                    <template  class="grow" v-for="(edu,i) in education" >
                      <v-list-item :key="i">
                        <div class="my-2">
                          <v-btn depressed small>{{edu.std}}</v-btn>
                        </div>
                        <v-btn class="ma-2" color="teal lighten-1" dark>
                          <v-icon dark>account_balance</v-icon>
                        </v-btn>
                        <v-list-item-content>
                          <v-list-item-title>{{edu.name}}</v-list-item-title>
                        </v-list-item-content>
                        <v-btn class="mx-2" fab dark small color="primary">
                          {{edu.marks}}
                        </v-btn>
                      </v-list-item>
                      <v-divider></v-divider>
                    </template>


                    <v-card-text class="headline font-weight-bold">
                    </v-card-text>
                  </v-card>
                </template>
            </v-col>


            <! ---------------Skills-------------------->
            <v-col>
            <template>
              <v-card
                class="mt-2 mb-2 mr-2"
              >
                <v-card-title>
                  Skills
                </v-card-title>
                <v-divider></v-divider>

                <template  class="grow" v-for="(skill,i) in skills" >
                  <v-list-item :key="i">
                    <v-btn class="ma-2" color="teal lighten-1" dark>
                      <v-icon dark>security</v-icon>
                    </v-btn>
                    <div class="my-2">
                      <v-btn depressed small>{{skill.name}}</v-btn>
                    </div>
                    <v-spacer></v-spacer>
                    <v-rating
                      v-model="skill.rating"
                      v-bind:readonly="true"
                      background-color="purple lighten-3"
                      color="purple"
                      small
                    ></v-rating>
                  </v-list-item>
                  <v-divider></v-divider>
                </template>

                <v-card-text class="headline font-weight-bold">
                </v-card-text>
              </v-card>
            </template>


                <! ------------------Projects-------------------->

                <template>
                  <v-card
                    class="mt-2 mb-2"
                  >
                    <v-card-title>
                      Projects
                    </v-card-title>
                    <v-divider></v-divider>

                    <template  class="grow" v-for="(project,i) in projects" >
                      <v-list-item :key="i">

                        <v-icon dark color="teal lighten-1">widgets</v-icon>

                        <div class="my-2">
                          <v-btn depressed small>{{project.name}}</v-btn>
                        </div>
                        <v-spacer></v-spacer>
                        <v-icon color="teal lighten-1" v-on:click="openLink(project.link)">insert_link</v-icon>

                      </v-list-item>
                      <v-divider></v-divider>
                    </template>

                    <v-card-text class="headline font-weight-bold">
                    </v-card-text>
                  </v-card>
                </template>
            </v-col>

                <! ----------------------- Achievments -------------------------->

            <v-col>
                <template>
                  <v-card
                    class="mt-2 mb-2"
                  >
                    <v-card-title>
                      Achievements
                    </v-card-title>
                    <v-divider></v-divider>

                    <template  class="grow" v-for="(achievement,i) in achievements" >
                      <v-list-item :key="i">

                        <v-icon dark color="teal lighten-1">emoji_events</v-icon>

                        <div class="my-2">
                          <v-btn depressed small>{{achievement.name}}</v-btn>
                        </div>
                        <v-spacer></v-spacer>
                        <v-icon color="teal lighten-1" v-on:click="openLink(achievement.link)">insert_link</v-icon>

                      </v-list-item>
                      <v-divider></v-divider>
                    </template>

                    <v-card-text class="headline font-weight-bold">
                    </v-card-text>
                  </v-card>
                </template>

                <! ---------------------Online Platforms ------------------------>


                <template>
                  <v-card
                    class="mt-2 mb-2"
                  >
                    <v-card-title>
                      Online Platforms
                    </v-card-title>
                    <v-divider></v-divider>
                    <template>
                      <v-row justify="center" align="center">

                        <v-list-item  class="grow">
                          <v-spacer></v-spacer>
                          <v-list-item-avatar size="50px" color="teal lighten-1" class="mr-2">
                            <v-img
                              class="elevation-6"
                              v-bind:src="platforms[0].link"
                              v-on:click="openLink(platforms[0].profileLink)"

                            ></v-img>
                          </v-list-item-avatar>
                          <v-list-item-avatar size="50px" color="teal lighten-1">
                            <v-img
                              class="elevation-6"
                              v-bind:src="platforms[1].link"
                              v-on:click="openLink(platforms[1].profileLink)"
                            ></v-img>
                          </v-list-item-avatar>
                          <v-spacer></v-spacer>
                        </v-list-item>
                      </v-row>

                      <v-list-item class="grow">
                        <v-row justify="center" align="center">
                          <v-list-item-avatar size="50px"  color="teal lighten-1">
                            <v-img
                              class="elevation-6"
                              v-bind:src="platforms[2].link"
                              v-on:click="openLink(platforms[2].profileLink)"
                            ></v-img>
                          </v-list-item-avatar>
                          <v-list-item-avatar size="50px" color="teal lighten-1" >
                            <v-img
                              class="elevation-6"
                              v-bind:src="platforms[3].link"
                              v-on:click="openLink(platforms[3].profileLink)"
                            ></v-img>
                          </v-list-item-avatar>
                          <v-list-item-avatar size="50px" color="teal lighten-1">
                            <v-img
                              class="elevation-6"
                              v-bind:src="platforms[4].link"
                              v-on:click="openLink(platforms[4].profileLink)"
                            ></v-img>
                          </v-list-item-avatar>
                        </v-row>
                      </v-list-item>

                      <v-row justify="center">
                        <v-list-item class="grow">
                          <v-spacer></v-spacer>
                          <v-list-item-avatar size="50px" color="teal lighten-1" class="mr-2">
                            <v-img
                              class="elevation-6"
                              v-bind:src="platforms[5].link"
                              v-on:click="openLink(platforms[5].profileLink)"
                            ></v-img>
                          </v-list-item-avatar>
                          <v-list-item-avatar size="50px" color="teal lighten-1">
                            <v-img
                              class="elevation-6"
                              v-bind:src="platforms[6].link"
                              v-on:click="openLink(platforms[6].profileLink)"
                            ></v-img>
                          </v-list-item-avatar>
                          <v-spacer></v-spacer>
                        </v-list-item>
                      </v-row>
                    </template>

                    <v-card-text class="headline font-weight-bold">
                    </v-card-text>
                  </v-card>
                </template>
            </v-col>




            <v-col>
                <template>
                  <v-card
                    class="mt-2 mb-2 mr-3"
                  >
                    <v-card-title>
                      Hobbies
                    </v-card-title>
                    <v-divider></v-divider>


                    <v-card-text class="headline font-weight-bold">
                    </v-card-text>
                  </v-card>
                </template>
                <template>
                  <v-card
                    class="mt-2 mb-2 mr-3"
                  >
                    <template v-for="icon in connectionIcons">
                      <v-list>
                        <v-list-item>
                          <v-list-item-avatar size="40px">
                            <v-img size="40px" v-bind:src="icon.image"></v-img>
                          </v-list-item-avatar>
                        </v-list-item>
                      </v-list>
                    </template>
                    <v-card-text class="headline font-weight-bold">
                    </v-card-text>
                  </v-card>
                </template>
            </v-col>
          </v-row>

          <v-snackbar
            v-model="snackBar"
          >
            {{ snackBarText }}
            <v-btn
              color="pink"
              text
              @click="snackBar = false"
            >
              Close
            </v-btn>
          </v-snackbar>
              </v-card>
            </v-dialog>
          </v-row>


          <v-row justify="center">
            <v-dialog v-model="leaderBoardDialog" width="500">
              <template v-slot:activator="{ on }">
              <v-list-item link >
                <v-btn  v-bind:color="colorName"
                        dense
                        dark width="100%" height="50px" v-on="on" v-on:click="showLeaderBoard(num2)">LeaderBoard
                </v-btn>
              </v-list-item>
            </template>
            <v-card v-bind:color="colorName" width="600px" class="white--text">
              <v-card-title class="white--text">
                {{dialogTitle}}
                <v-spacer></v-spacer>
                <v-text-field
                  class="white--text"
                  append-icon="search"
                  label="Search or Click on person name or column name"
                  single-line
                  hide-details
                  v-model="search"
                ></v-text-field>
              </v-card-title>
              <v-data-table

                :headers="headers"
                :items="items"
                :search="search"

              >
                <template v-slot:body="{ items }">
                  <tr v-for="item in items" @click="showProfile(item.RegNo)" >
                    <td>{{ item.name }}</td>
                    <td class="text-xs-right">{{ item.RegNo }}</td>
                    <td class="text-xs-right">{{ item.like }}</td>
                    <td class="text-xs-right">{{ item.dislike }}</td>
                  </tr>
                </template>
                <v-alert slot="no-results" :value="true" color="error" icon="warning">
                  Your search for "{{ search }}" found no results.
                </v-alert>
              </v-data-table>
            </v-card>
            </v-dialog>
          </v-row>


          <v-row justify="center">
            <v-dialog v-model="dialog1" width="500">
              <template v-slot:activator="{ on }">
                <v-list-item link >
                  <v-btn
                    v-bind:color="colorName"
                    dense
                    dark width="100%" height="50px" v-on="on">About Us</v-btn>
                </v-list-item>
              </template>
              <v-card v-bind:color="colorName" class="white--text">

                <v-card-title>
                  About Us
                </v-card-title>
                <v-divider></v-divider>

                <v-card-subtitle class="white--text">
                  <p class="subtitle-1">It is a Capstone Project by</p>
                  <p>Vishal Kumar<br>
                    Koustav Manna<br>
                    Akash Khanra<br>
                    Mohan Bera</p>
                  <p class="subtitle-1 text-right">Mentored by<br>Mr. Sami Anand</p>
                  <p class="subtitle-1">Frameworks used</p>
                  <v-row class="justify-left">


                    <v-avatar size="10%">
                      <v-img size="20%"style="border: white 2px solid" src="https://avatars3.githubusercontent.com/u/8124623?s=400&v=4"></v-img>

                    </v-avatar>



                    <v-avatar size="10%">
                      <v-img size="20%"style="border: white 2px solid" src="https://icon-library.net/images/jquery-icon-png/jquery-icon-png-28.jpg"></v-img>
                    </v-avatar>

                    <v-avatar size="10%">
                      <v-img size="20%"style="border: white 2px solid" src="https://semantic-ui.com/images/logo.png"></v-img>
                    </v-avatar>




                    <v-avatar size="10%">
                      <v-img size="20%"style="border: white 2px solid" src="https://vuejs.org/images/logo.png"></v-img>
                    </v-avatar>

                  </v-row>
                  <v-row>
                    <p> Vert.X JQuery  Semantic-UI VueJS<p>
                    <p>
                    </p>
                  </v-row>


                  <v-row>

                  </v-row>
                </v-card-subtitle>
                <br>
                <v-divider></v-divider>
                <v-card-actions>

                  <v-btn

                    text
                    @click="dialog1 = false"
                    class="white--text"
                  >
                    Cancel
                  </v-btn>
                  <v-spacer></v-spacer>

                  <v-btn

                    text
                    @click="alert1"
                    class="white--text"
                  >
                    GitHub
                  </v-btn>

                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-row>

          <v-row justify="center">
            <template>

                <v-list-item link>
                <v-btn
                  :disabled="dialog3"
                  :loading="dialog3"
                  class="white--text"
                  v-bind:color="colorName"
                  dense
                  @click="dialog3 = true"
                  width="100%"
                  height="50px"
                >
                  Log Out
                </v-btn>
                </v-list-item>
                <v-dialog
                  v-model="dialog3"
                  hide-overlay
                  persistent
                  width="300"
                >
                  <v-card
                    v-bind:color="colorName"
                    dark
                  >
                    <v-card-text>
                      Thank You For Visiting us
                      <v-progress-linear
                        indeterminate
                        color="white"
                        class="mb-0"
                      ></v-progress-linear>
                    </v-card-text>
                  </v-card>
                </v-dialog>
            </template>
          </v-row>


        </v-list>
      </v-navigation-drawer>
    </v-sheet>

    <div id="mainBody">
      <button id="addQuestion" style="position: absolute; bottom: 30px;right: 50px; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);" class="circular ui purple icon button">
        <i class="icon edit outline"></i>
      </button>

      <div id="searchBar" style="position: absolute; top:25%; width: 50%; box-shadow: 10px 10px 5px 0px rgba(0,0,0,0.75);" v-bind:style="searchBarLeft" class="ui fluid green action input">
        <input id="search" type="text" placeholder="Search...">
        <div id="searchButton" class="ui button">Search</div>
      </div>


      <div id="nextDiv" style=" float:left;
overflow-y: auto; overflow-x: hidden;  height: 75%; position: absolute; width: 70%; top: 30%; left: 17%">

      </div>

      <div v-if="!mobile" style="position:absolute; color: grey;left: 20px; top: 60px; box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45);" class="ui selection dropdown">
        <input type="hidden" name="select">
        <i class="dropdown icon"></i>
        <div class="default text">Select</div>
        <div class="menu" style="box-shadow: 6px 6px 2px 0px rgba(0,0,0,0.45)">
          <div class="item" onclick="handleShowQuestions('recent')"><i class="clock outline icon"></i>Most Recent</div>
          <div class="item" onclick="handleShowQuestions('mostVisited')"><i class="tag icon"></i>Most Viewed</div>
        </div>
      </div>
    </div>

  </v-app>
</div>


<script>

  var ansCount1=0;
  function answerCount() {
    ansCount1=ansCount1+1;
    return ansCount1;
  }

  var commentOn=false;
  function commentReset() {
    commentOn=false;
  }
  var set1=new Set();
  function resetSet()
  {
    ansCount1=0;
    set1=new Set();
  }


  function editComment(id)
  {
    if(!commentOn)
    {
      $.ajax({

        url: "/editComment",

        data:
          {
            ID: id,
          },
        success: function(data)
        {
          if(data==='login error')
          {
            location.reload();
          }
          else
          {
            commentOn=true;
            $('#comments'+id).prepend(data);
          }
        }
      });
    }
  }

  function commentCancelAction(id)
  {
    $("#commentBar"+id).remove();
    commentReset();
  }

  function commentSaveAction(id)
  {
    var comment=$("#commentText"+id).val();
    comment=comment.trim();
    if(comment.length>0)
    {
      $.ajax({

        url: "/saveComment",

        data:
          {
            comment: comment,
            ID:id,
          },
        success: function (data)
        {
          if(data==='login error')
          {
            location.reload();
          }
          else if(data==='error')
          {
            alert("Something went wrong!");
          }
          else
          {
            var num01=$("#showComments"+id).html();
            var yo=num01.split(">");
            var len1=yo.length;
            var num1=parseInt(yo[len1-1]);
            var num2=num1+1;
            $("#showComments"+id).html("<i class=\"comment outline icon \"></i>"+num2);
            $("#commentBar"+id).remove();
            commentReset();
            showCommentsAction(id);
          }

        }
      });
    }
    else
    {
      alert("Comment can't be empty, Please click the cancel button");
    }
  }

  function showCommentsAction(id)
  {

    $.ajax({

      url: "/showComments",

      data:
        {
          ID:id,
        },
      success: function (data)
      {
        if(data==='login error')
        {
          location.reload();
        }
        else if(data==='error')
        {
          alert("Something went wrong!");
        }
        else
        {
          $("#comments"+id).empty();
          $("#comments"+id).append(data);
          commentReset();
        }

      }
    });
  }

  $(function(){



    $("#addQuestion").click(function ()
    {
      $.ajax({

        url: "/newQuesEdit",

        data:
          {
            data: 'yo',
          },
        success: function(data)
        {
          $("#searchBar").hide();
          $("#nextDiv").empty();
          $("#nextDiv").append(data);

        }
      });
    });



    $("#searchButton").click(function () {
      commentReset();
      resetSet();
      $("#nextDiv").empty();

      $.ajax({

        url: "/searchData",

        data:
          {
            data: $("#search").val(),
          },
        success: function(data)
        {

          $("#searchBar").css("top", "10%");
          $("#nextDiv").css("top", "20%");
          $("#nextDiv").append(data);

        }
      });
    });
  });



  function handleShowQuestions(type)
  {
    commentReset();
    resetSet();
    $("#nextDiv").empty();

    $.ajax({

      url: "/showQuestions",

      data:
        {
          type:type,
        },
      success: function(data)
      {

        $("#searchBar").css("top", "10%");
        $("#nextDiv").css("top", "20%");
        $("#nextDiv").append(data);

      }
    });
  }

  function handleRating (id,value,content) {
    var str=id.split(".");
    var ansID=str[1];
    var type="";
    if(str[0][0]==='y')
    {
      type="Y";
    }
    else
    {
      type="B";
    }

    $.ajax({

      url: "/rating",

      data:
        {
          ID: ansID,
          val: value,
          type: type,
        },
      success: function (data) {
        if (data === 'error') {
          alert("something went wrong");
        } else if (data === 'login error') {
          location.reload();
        } else {
          if(type==="Y")
          {
            var str1 = $("#numLike"+ansID).html();
            var strArr = str1.split(">");
            var num1 = parseInt(strArr[strArr.length - 1]);
            var str2=data.split(" ");
            var value1=parseInt(str2[1]);
            num1 = num1 + value1;
            $("#numLike"+ansID).html("<i class=\"heart icon\"></i>"+num1);
          }
          else
          {
            var str1 = $("#numDislike"+ansID).html();
            var strArr = str1.split(">");
            var num1 = parseInt(strArr[strArr.length - 1]);
            var str2=data.split(" ");
            var value1=parseInt(str2[1]);
            num1 = num1 + value1;
            $("#numDislike"+ansID).html("<i class=\"thumbs down outline icon\"></i>"+num1);
          }
        }
      }
    });
  }

</script>



<script src="https://cdn.jsdelivr.net/npm/vue@2.x/dist/vue.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js"></script>
<script>
  new Vue({
    el: '#app',
    vuetify: new Vuetify(),

    data() {
      return {
        drawer: null,
        sliderWidth: "25%",
        searchBarLeft: "left: 25%",
        mobile: false,
        profileName: '',
        profileReg: '',
        items: [
          {title: 'Profile', icon: 'widgets'},
          {title: 'Leaderboard', icon: 'question_answer'},
        ],
        dialog: false,
        dialog1: false,
        notifications: false,
        sound: true,
        widgets: false,
        dialog3: false,
        leaderBoardDialog: false,
        information: {},
        profilePic: '',
        colorName: "teal lighten-1",
        colorCombo:
          [
            {name: "Pink", color: "pink lighten-2"}, {name: "Red", color: "red darken-1"}, {
            name: "Purple",
            color: "purple darken-1"
          }, {name: "Teal", color: "teal lighten-1"}
          ],
        search: '',
        headers: [
          {
            text: 'Name',
            align: 'left',
            sortable: false,
            value: 'name'
          },
          {
            text: 'Reg-No',
            sortable: false,
            value: 'RegNo'
          },
          {text: 'Like', value: 'like'},
          {text: 'Dislike', value: 'dislike'},
        ],
        items: [],

        dialogForEditor: false,
        profileOwner: false,

        profile:
          {},

        education: [],

        skills:
          [],

        projects:
          [],
        achievements:
          [],
        platforms:
          [
            {
              name: "Hackerearth",
              link: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQZV5a2Zh7EJN1L_fGrf8jxzFoGEZN3-Av_FvYOJWfoH1cb1Fnv",
              profileLink: ""
            }, {
            name: "HackerRank",
            link: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQAYE3OogET_lRRw86Rp-n45vJ-3fkDkSCJWBWiqTPSnA1luL2s",
            profileLink: ""
          }, {
            name: "Codechef",
            link: "https://miro.medium.com/max/452/1*1W0-bbmt4iiEpp_pPrS0VQ.png",
            profileLink: ""
          }, {
            name: "Codeforces",
            link: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSkwCuxICfzzQ-Jw7rqLGkhqfhD6EeEeNyplV39ZjmLWd1Um2PC",
            profileLink: ""
          },
            {
              name: "Geeksforgeeks",
              link: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSpeppScfsq_oLWwH0g8dflU89vTKlU_oQqPoHfqmbFA7zddSou",
              profileLink: ""
            }, {
            name: "Github",
            link: "https://github.githubassets.com/images/modules/logos_page/Octocat.png",
            profileLink: ""
          }, {
            name: "StackOverflow",
            link: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR51gjwFv7IdwNJ1yQhflz_WcIQt6nuzPzf6HepiXAsNNNba2sr",
            profileLink: ""
          }
          ],
        connection:
          [],

        connectionIcons: [{"image": "http://icons.iconarchive.com/icons/dtafalonso/android-l/256/Gmail-icon.png"},
          {"image": "http://icons.iconarchive.com/icons/danleech/simple/256/linkedin-icon.png"}, {"image": "http://icons.iconarchive.com/icons/limav/flat-gradient-social/256/Twitter-icon.png"}, {"image": "http://icons.iconarchive.com/icons/danleech/simple/256/facebook-icon.png"}
        ],

        profileEdit: {},
        educationEdit: [],
        skillsEdit: [],
        projectsEdit: [],
        achievementsEdit: [],
        platformsEdit: [],
        connectionEdit: [],
        menu: false,
        space: "  ",

        message: '',
        on: '',
        snackBar: false,
        snackBarText: '',
        rowColor: '',

        messageList: [],
        messageListFull: false,
        notificationList: [],
        notificationListFull: false,

        notificationMessage: '',
        notificationRegNo: '',
        switch1: true,
        dialogTitle: '',
        num1: '1',
        num2: '2',

        hobbies:
          [
            {name: "Competitive Programming"}, {name: "football"}
          ],
        outQuestions:
          [],
        menuForMail: [],
        menuForOutMail: false,
        mailMessage: "",
        mailReciever: '',
        mailPlaceholder: '',
        mailMinWidth: "40%",
        allMailMinWidth: "30%",
      }
    },
    methods:
      {
        hello() {

        },
        alert1() {
          this.dialog1 = false;
          window.open("https://github.com/mohanbera/askLPU", "_blank");
        },
        changeColor(data) {
          this.colorName = data;
        },

        showProfile(data) {
          this.dialog = true;
          axios
            .post("/profileInfo", {
                headers: {
                  "Content-Type": "application/javascript"
                }
              },
              {data: {regNo: data}}
            ).then(response =>
          {
            this.profile = response.data.profile;
          this.education = response.data.education;
          this.skills = response.data.skills;
          this.projects = response.data.projects;
          this.achievements = response.data.achievements;
          this.platforms = response.data.platforms;
          this.connection = response.data.connection;
          this.profileOwner = response.data.profileOwner;
        }).
          catch(error =>
          {}
        )
          ;
        },
        showLeaderBoard(num) {

          if(num==='1')
          {
            this.dialogTitle='Search any person';
          }
          else
          {
            this.dialogTitle='Leader-Board';
          }
          this.leaderBoardDialog=true;
          axios
            .get('/leaderBoard')
            .then(response => (this.items = response.data)
        )
          ;
        },
        saveEditor() {
          this.profileEdit = JSON.parse(JSON.stringify(this.profile));
          this.educationEdit = JSON.parse(JSON.stringify(this.education));
          this.skillsEdit = JSON.parse(JSON.stringify(this.skills));
          this.projectsEdit = JSON.parse(JSON.stringify(this.projects));
          this.achievementsEdit = JSON.parse(JSON.stringify(this.achievements));
          this.platformsEdit = JSON.parse(JSON.stringify(this.platforms));
          this.connectionEdit = JSON.parse(JSON.stringify(this.connection));
        },
        saveEditorData() {
          axios
            .post("/saveProfileData", {
                headers: {
                  "Content-Type": "application/javascript"
                }
              },
              {
                data: {
                  regNo: this.profileReg,
                  profile: this.profileEdit,
                  education: this.educationEdit,
                  skills: this.skillsEdit,
                  projects: this.projectsEdit,
                  achievements: this.achievementsEdit,
                  platforms: this.platformsEdit,
                  connection: this.connectionEdit
                }
              }
            ).then(response =>
          {
            if(response.data === 'OK'
        )
          {
            this.profile = JSON.parse(JSON.stringify(this.profileEdit));
            this.education = JSON.parse(JSON.stringify(this.educationEdit));
            this.skills = JSON.parse(JSON.stringify(this.skillsEdit));
            this.projects = JSON.parse(JSON.stringify(this.projectsEdit));
            this.achievements = JSON.parse(JSON.stringify(this.achievementsEdit));
            this.platforms = JSON.parse(JSON.stringify(this.platformsEdit));
            this.connection = JSON.parse(JSON.stringify(this.connectionEdit));
          }
        else
          {
            console.log("something went wrong")
          }
        }).
          catch(error =>
          {}
        )
          ;
        },

        cancelEditorData() {

        },

        openLink(link) {
          window.open(link, "_blank");
        },
        messageSendAction() {
          if (this.message.length > 0) {
            axios
              .post('/sendMessage', {
                  headers: {
                    "Content-Type": "application/javascript"
                  }
                },
                {
                  data: {
                    reciever: this.profile.name,
                    message: this.message,
                    image: this.profile.image,
                    regNo: this.profile.regNo,
                  }
                })
              .then(response => {
              if(response.data === 'OK'
          )
            {
              this.snackBar = true;
              this.snackBarText = 'Message sent';
            }
          else
            {
              this.snackBar = true;
              this.snackBarText = 'Something went wrong';
            }
          })
            ;
          } else {
            this.snackBarText = "Message length can not be zero";
            this.snackBar = true;
          }
        },

        showMessages() {
          axios
            .post('/showMessages')
            .then(response => {
            if(response.data !== 'login error'
        )
          {
            if (response.data.message.length > 0) {
              response.data.message = response.data.message.reverse();
              this.messageList = response.data.message;
              this.messageListFull = true;
            } else {
              this.messageListFull = false;
            }
          }
        else
          {
            this.snackBar = true;
            this.snackBarText = 'Something went wrong';
          }
        })
          ;
        },

        showNotification() {
          axios
            .post('/showNotification')
            .then(response => {
            if(response.data !== 'login error'
        )
          {
            if (response.data.notifications.length > 0) {
              console.log(response.data.notifications);
              response.data.notifications = response.data.notifications.reverse();
              this.notificationList = response.data.notifications;
              this.notificationListFull = true;
            } else {
              this.notificationListFull = false;
            }
          }
        else
          {
            this.snackBar = true;
            this.snackBarText = 'Something went wrong';
          }
        })
          ;
        },

        sendNotification() {
          axios.post("/sendNotification", {
              headers: {
                "Content-Type": "application/javascript"
              }
            },
            {
              data: {
                senderName: this.profileName,
                notificationMessage: this.notificationMessage,
                regNums: this.notificationRegNo,
                sendToAll: this.switch1,
              }
            }).then(response =>
          {
            if(response.data === 'OK'
        )
          {
            this.notificationRegNo = '';
            this.notificationMessage = '';
            this.snackBar = true;
            this.snackBarText = 'Notification sent';
          }
        else
          {
            this.snackBar = true;
            this.snackBarText = 'Something went wrong';
          }
        })
          ;
        },

        showOutQuestions() {
          axios.post("/getUserQuery").then(response =>
          {
            if(response.data !== 'login error'
        )
          {
            this.outQuestions = response.data;
          }
        else
          {
            this.snackBar = true;
            this.snackBarText = 'Something went wrong';
          }
        })
          ;
        },

        deleteQuesAction(index) {
          console.log(index);
          console.log(this.outQuestions[index]);
          axios.post("/deleteUserQuery", {
              headers: {
                "Content-Type": "application/javascript"
              }
            },
            {
              data: {
                deleteData: this.outQuestions[index],
              }
            }).then(response =>
          {
            if(response.data === 'OK'
        )
          {
            this.$delete(this.outQuestions,index);
            this.$delete(this.menuForMail, index);
            this.snackBar = true;
            this.snackBarText = 'Quetion deleted';
          }
        else
          {
            this.snackBar = true;
            this.snackBarText = 'Something went wrong';
          }
        })
          ;
        },

        showMenuForMail(data)
        {
          this.menuForOutMail = true;
          this.mailReciever=data;
          this.mailMessage='';
          this.mailPlaceholder='Write your mail to '+data+'...';
        },

        sendMail()
        {
          var len=this.mailMessage.trim().length;
          if(len > 1) {
            axios.post("http://localhost:8080/sendMail", {
                headers: {
                  "Content-Type": "application/javascript",
                }
              },
              {
                data: {
                  to: this.mailReciever,
                  message: this.mailMessage,
                }
              }).then(response =>
            {
              if(response.data === 'OK'
          )
            {
              this.snackBar = true;
              this.snackBarText = 'mail has been sent to ' + this.mailReciever;
              this.mailReciever = '';
              this.mailMessage = '';
            }
          else
            {
              this.snackBar = true;
              this.snackBarText = 'Something went wrong';
            }
          })
            ;
          }
          else
          {
            this.snackBar = true;
            this.snackBarText = 'Please write something mail is too short';
          }

        }
      },

        mounted: function () {
          this.$nextTick(function () {


            var height=window.screen.availHeight;
            var width=window.screen.availWidth;
            if(height>=width)
            {
              this.sliderWidth='90%';
              this.searchBarLeft="left: 10%";
              this.mobile=true;
              this.mailMinWidth="90%";
              this.allMailMinWidth="30%";
            }

            axios
              .get('/information')
              .then(response => (this.profileName = response.data.name, this.profilePic = response.data.pp, this.profileReg = response.data.reg)
          )
            ;
          })
        },
        watch: {
          dialog3(val) {
            if (!val) return;
            var cookies = document.cookie.split(";");
            for (var i = 0; i < cookies.length; i++) {
              var cookie = cookies[i];
              var eqPos = cookie.indexOf("=");
              var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
              document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
            }
            setTimeout(() => {this.dialog3 = false;
            window.location.reload();
          },
            3000
          )
            ;

          },
        }

  });
</script>
</body>
</html>

