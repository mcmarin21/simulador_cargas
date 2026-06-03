String prefixLabel(int prefijo) {
  switch (prefijo) {
    case -12: return ' p';
    case -9:  return ' n';
    case -6:  return ' μ';
    case -3:  return ' m';
    case 0:   return '';
    case 3:   return ' k';
    case 6:   return ' M';
    default:  return '×10^$prefijo';
  }
}