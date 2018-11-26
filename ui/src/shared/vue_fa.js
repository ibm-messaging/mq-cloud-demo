/**
 * © Copyright IBM Corporation 2018
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/
import Vue from 'vue';

import { library } from '@fortawesome/fontawesome-svg-core';
import { faArrowLeft, faCheck, faTimes, faExclamation } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

library.add(faArrowLeft, faCheck, faTimes, faExclamation);

Vue.component('font-awesome-icon', FontAwesomeIcon);

export default {
  name: 'FontAwesomeIcon'
}
