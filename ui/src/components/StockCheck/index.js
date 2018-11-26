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
import axios from 'axios';
import fa from '../../shared/vue_fa';
import globals from '../../globals';

console.log(globals.LAMBDA_URL);

let randomCount = () => {
  return Math.floor(Math.random()*(50-0+1)+0);
}

let locations = {
  winchester: 0,
  hursley: 0
}

Vue.component('stock-check', {
  props: ['product'],
  template: `
  <b-card class="d-flex flex-column mb-2 pt-3 pb-3">
    <div class="flex-grow-1">
      <div class="col-sm-12">
        <h4>Check Stock</h4>
        <p>View stock levels for this product.</p>
        <div class="d-flex mt-3">
          <b-button :disabled="stock.checking" v-on:click="checkStock(storeLocation, product)" class="p-2" variant="primary">
            <span v-if="!stock.checking">Click to Check</span>
            <span v-if="stock.checking">Checking</span>
          </b-button>
          <span v-if="stock.checking" class="ml-3 mt-2 spinner"></span>
          <div class="stock__status ml-3 mt-1"  v-if="stock.checked">
            <span v-if="stock.count === 0"> Product not currently available. <font-awesome-icon :icon="['fas', 'times']" class="text-danger font-weight-bold ml-1" /></span>
            <span v-if="stock.count > 0 && stock.count < 10"> Hurry, limited stock, only {{stock.count}} available <font-awesome-icon :icon="['fas', 'exclamation']" class="text-warning font-weight-bold ml-1" /></span>
            <span v-if="stock.count > 10"> Great! we have {{stock.count}} in stock! <font-awesome-icon :icon="['fas', 'check']" class="text-success font-weight-bold ml-1"/></span>
          </div>
        </div>
      </div>
    </div>
  </b-card>
  `,
  components: {
    fa
  },
  data: () => {
    return {
      storeLocation: '',
      stock: stockCheck.stock,
    }
  },
  created() {
    // For debugging purposes only
    Object.keys(locations).forEach((key) => {
      locations[key] = randomCount();
    });
    stockCheck.stock.id = this.product.id;
  },
  methods: {
    checkStock: (storeLocation, product) => {
      stockCheck.stock.count = 0;
      stockCheck.stock.checked = false;
      stockCheck.stock.checking = true;
      axios.post(globals.LAMBDA_URL,
        {"product": product.id})
        .then((res) => {
          if (stockCheck.stock.checking) {
            let resObj = JSON.parse(res.data);
            if (typeof resObj.count !== 'undefined') {
              Vue.set( stockCheck.stock, 'count', resObj.count);
            }
            stockCheck.stock.checked = true;
            stockCheck.stock.checking = false;
          }
        })
        .catch((err) => {
          stockCheck.stock.checking = false;
          stockCheck.stock.checked = true;
        });
    }
  },
  destroyed() {
    // return stockCheck back to default
    stockCheck.stock.id = null;
    stockCheck.stock.count = 0;
    stockCheck.stock.checked = false;
    stockCheck.stock.checking = false;
  },
});

let stockCheck = new Vue({
  data: {
    stock: {
      id: '',
      count: 0,
      checked: false,
      checking: false
    }
  }
});

export default {
  stockCheck,
  name: 'StockCheck'
}
