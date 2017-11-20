import * as i18next from 'i18next';
import moment from 'moment';
import en from './en.json';
import ja from './ja.json';

const i18n = i18next
  .init({
    resources: {
      en: {
        general: {
          ...en
        }
      },
      ja: {
        general: {
          ...ja
        }
      }
    },

    fallbackLng: 'en',

    // string or array of namespaces to load
    ns: ['general'],

    defaultNS: 'general',

    interpolation: {
      escapeValue: false, // not needed for react
      formatSeparator: ',',
      format: (value, format, lng) => {
        if (format === 'uppercase') return value.toUpperCase();
        if(value instanceof Date) return moment(value).format(format);
        return value;
      }
    },

    // react-i18next special options (optional)
    react: {
      wait: true,  // true: wait for loaded in every translated hoc
    }
  });

export default i18n;