<script>
import { applicationMixin } from "src/modules/application_mixin.js";
import { cloneDeep } from 'lodash';
const WEEK_DAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

export default {
  mixins: [applicationMixin],
  data: function () {
    return {
      weekDays: WEEK_DAYS.map(day => { return { day, newOpenTime: null, newCloseTime: null } }),
      weekOpeningHours: [],
      deletedOpeningsIds: [],
    }
  },
  mounted() {
    this.initWeekOpeningHours();
  },
  methods: {
    initWeekOpeningHours() {
      this.weekOpeningHours = [];
      WEEK_DAYS.forEach((day, index) => {
        this.weekOpeningHours.push(this.getDayOfWeekOpeningHours(index));
      });
    },
    getDayOfWeekOpeningHours(index) {
      return globalState.pageModel.shop_info.opening_hours
        .filter(h => h.week_day === index+1)
        .sort((a,b) => {
          const date1 = new Date(a.open_time);
          const date2 = new Date(b.open_time);
          return date1 > date2;
        }).map(t => {
          const time = cloneDeep(t);
          time.open_time = this.formatTime(time.open_time);
          time.close_time = this.formatTime(time.close_time);
          return time;
        });
    },
    formatTime(time) {
      const t = new Date(Date.parse(time));
      const h = t.getHours();
      const m = t.getMinutes();
      const postfix = h >= 12 ? 'PM' : 'AM';
      const minute = m >= 10 ? `${m}` : `0${m}`;
      let hour = `${h % 12 == 0 ? 12 : h % 12}`;
      hour = hour.length < 2 ? `0${hour}` : hour;
      return `${hour}:${minute} ${postfix}`;
    },
    deleteOpeningHour(dayIndex, openingIndex) {
      const openingId = this.weekOpeningHours[dayIndex][openingIndex].id;
      if (!!openingId) {
        this.deletedOpeningsIds.push(openingId);
      }
      Vue.delete(this.weekOpeningHours[dayIndex], openingIndex);
    },
    addOpeningHour(dayIndex) {
      const index = this.weekOpeningHours[dayIndex].length;
      if (this.weekDays[dayIndex].newOpenTime && this.weekDays[dayIndex].newCloseTime) {
        this.weekOpeningHours[dayIndex].push({
          week_day: dayIndex + 1,
          open_time: this.weekDays[dayIndex].newOpenTime,
          close_time: this.weekDays[dayIndex].newCloseTime
        });
        this.weekDays[dayIndex].newOpenTime = null;
        this.weekDays[dayIndex].newCloseTime = null;
      }
    },
    update() {
      this.weekDays.forEach((day, index) => {
        this.addOpeningHour(index);
      });
      ApplicationModule.post({
        url: "/api/v1/opening_hours",
        data: {
          week_opening_hours: this.weekOpeningHours,
          deleted_openings_ids: this.deletedOpeningsIds,
        },
        success: (data) => {
          Vue.set(globalState.pageModel.shop_info, 'opening_hours', data["opening_hours"]);
          this.initWeekOpeningHours();
        },
        error: (err) => {
          console.error(err);
        }
      });
    }
  },
  computed: {
    availableTimes() {
      const times = [];
      const hours = ['12','01','02','03','04','05','06','07','08','09','10','11'];
      const minutes = ['00','15','30','45'];
      const postfixes = ['AM', 'PM'];
      for (let postfix in postfixes) {
        for (let hour in hours) {
          for (let minute in minutes) {
            times.push(`${hours[hour]}:${minutes[minute]} ${postfixes[postfix]}`);
          }
        }
      }
      return times;
    }
  }
}
</script>

<template>
  <div class="container">
    <div class="row">
      <div class="col-12">
        <h1>Openings</h1>
        <div class="py-5">
          <div v-for="(day, dayIndex) in weekDays" :key="`day-${dayIndex}`">
            <div class="d-flex flex-column">
              <div class="custom-control custom-checkbox mr-3">
                <input type="checkbox" class="custom-control-input" :id="`customCheck-${dayIndex}`" v-model="day.editing">
                <label class="custom-control-label" :for="`customCheck-${dayIndex}`">{{day.day}}</label>
              </div>
              <div v-if="day.editing" class="d-flex flex-column ml-4">
                <div
                  class="d-flex align-items-center py-3 flex-wrap"
                  v-for="(opening, openingIndex) in weekOpeningHours[dayIndex]"
                  :key="`editing-day-${dayIndex}-opening-${openingIndex}`"
                >
                  <select class="custom-select" v-model="opening.open_time" @change="opening.updated = true">
                    <option
                      v-for="time in availableTimes"
                      :selected="time === opening.open_time"
                      :value="time"
                      :key="`day-${dayIndex}-opening-${openingIndex}-time-${time}-open`"
                    >{{time}}</option>
                  </select>
                  <span class="px-4">-</span>
                  <select class="custom-select" v-model="opening.close_time" @change="opening.updated = true">
                    <option
                      v-for="time in availableTimes"
                      :selected="time === opening.close_time"
                      :value="time"
                      :key="`day-${dayIndex}-opening-${openingIndex}-time-${time}-close`"
                    >{{time}}</option>
                  </select>
                  <div class="ml-3">
                    <a href="javascript:void(0)" @click="deleteOpeningHour(dayIndex, openingIndex)"> Delete opening hour </a>
                  </div>
                </div>
                <div class="d-flex align-items-center py-3 flex-wrap">
                  <select class="custom-select" v-model="day.newOpenTime">
                    <option :value="null">--:--</option>
                    <option
                      v-for="time in availableTimes"
                      :value="time"
                      :key="`day-${dayIndex}-new-time-${time}-open`"
                    >{{time}}</option>
                  </select>
                  <span class="px-4">-</span>
                  <select class="custom-select" v-model="day.newCloseTime">
                    <option selected :value="null">--:--</option>
                    <option
                      v-for="time in availableTimes"
                      :value="time"
                      :key="`day-${dayIndex}-new-time-${time}-close`"
                    >{{time}}</option>
                  </select>
                </div>
                <div class="my-3">
                  <a href="javascript:void(0)" @click="addOpeningHour(dayIndex)"> Add opening hour </a>
                </div>
              </div>
              <div v-else>
                <div class="d-flex flex-column" v-if="weekOpeningHours[dayIndex] && weekOpeningHours[dayIndex].length > 0">
                  <div class="font-weight-bold ml-4" v-for="(opening, openingIndex) in weekOpeningHours[dayIndex]" :key="`day-${dayIndex}-opening-${openingIndex}`">
                    {{opening.open_time}} - {{opening.close_time}}
                  </div>
                </div>
                <div v-else>
                  <div class="font-weight-bold ml-4">
                    closed
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="d-flex my-5">
          <button class="btn btn-primary" @click="update()">
            Save
          </button>
          <button class="btn btn-secondary ml-3" @click="initWeekOpeningHours()">
            Discard
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>

  .custom-select {
    max-width: 8rem;
  }

</style>
