import Example from './Example.vue';

export default {
  title: 'Example',
  component: Example,
};

export const Primary = () => ({
  components: { Example },
  template: '<Example />',
});
