import illeg from './img/LLEG.png';
import irleg from './img/RLEG.png';
import iupperbody from './img/upperbody.png';
import ilowerbody from './img/lowerbody.png';
import irarm from './img/rarm.png';
import ilarm from './img/larm.png';
import ilpalm from './img/lpalm.png';
import ineck from './img/neck.png';
import ihead from './img/head.png';
import irpalm from './img/rpalm.png';
import irfoot from './img/rfoot.png';
import ilfoot from './img/lfoot.png';
import Arrowright from '../svg/Arrowright';
import Arrowleft from '../svg/Arrowleft';
import { flip, FloatingPortal, offset, shift, useFloating, useTransitionStyles } from '@floating-ui/react';
import React from 'react';
import { getItemUrl } from '../helpers';
import { isEnvBrowser } from './misc';
import { debugData } from './debugData';
debugData([
  {
    action: 'DamageCall',
    data: {
      HEAD: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: true,
        bleeding: false,
      },
      SPINE: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      LARM: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      RFOOT: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      RHAND: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      LFOOT: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      NECK: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      RLEG: {
        severity: true,
        percent: 60,
        bullets: 6,
        broken: false,
        bleeding: true,
      },
      LLEG: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      LOWER_BODY: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      LHAND: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      UPPER_BODY: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
      RARM: {
        severity: false,
        percent: 0,
        bullets: 0,
        broken: false,
        bleeding: false,
      },
    },
  },
]);

export default function Body({ detaileddata }: { detaileddata: any }) {
  const [hoverData, setHoverData] = React.useState<boolean>(false);
  const [bodypart, setBodypart] = React.useState<string>('');
  const [bodydamagecal, setBodydamagecal] = React.useState<any>(detaileddata);

  const { refs, context, floatingStyles } = useFloating({
    middleware: [flip(), shift(), offset({ mainAxis: 15, crossAxis: -20 })],
    open: hoverData,
    placement: 'right-start',
  });
  const { isMounted, styles } = useTransitionStyles(context, {
    duration: 200,
  });
  const handleMouseMove = ({ clientX, clientY }: MouseEvent | React.MouseEvent<unknown, MouseEvent>) => {
    refs.setPositionReference({
      getBoundingClientRect() {
        return {
          width: 0,
          height: 0,
          x: clientX,
          y: clientY,
          left: clientX,
          top: clientY,
          right: clientX,
          bottom: clientY,
        };
      },
    });
  };
  React.useEffect(() => {
    window.addEventListener('mousemove', handleMouseMove);

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
    };
  }, []);
  return (
    <div className="group" style={{ position: 'relative' }}>
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['UPPER_BODY']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Upperbody"
        src={isEnvBrowser() ? iupperbody : getItemUrl('upperbody')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LOWER_BODY']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Lowerbody"
        src={isEnvBrowser() ? ilowerbody : getItemUrl('lowerbody')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LLEG']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Lleg"
        src={isEnvBrowser() ? illeg : getItemUrl('lleg')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['RLEG']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Rleg"
        src={isEnvBrowser() ? irleg : getItemUrl('rleg')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['RARM']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Rhand"
        src={isEnvBrowser() ? irarm : getItemUrl('rarm')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LARM']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Larm"
        src={isEnvBrowser() ? ilarm : getItemUrl('larm')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LHAND']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Lparm"
        src={isEnvBrowser() ? ilpalm : getItemUrl('lpalm')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['NECK']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Neck"
        src={isEnvBrowser() ? ineck : getItemUrl('neck')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['HEAD']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Head"
        src={isEnvBrowser() ? ihead : getItemUrl('head')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['RHAND']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="Rarm"
        src={isEnvBrowser() ? irpalm : getItemUrl('rpalm')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['RFOOT']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="RFoot"
        src={isEnvBrowser() ? irfoot : getItemUrl('rfoot')}
      />
      <img
        style={{
          width: '100%',
          position: 'absolute',
          top: 0,
          left: 0,
          filter: `sepia(${bodydamagecal['LFOOT']?.percent}%) saturate(300%) brightness(100%) hue-rotate(299deg)`,
        }}
        alt="LFoot"
        src={isEnvBrowser() ? ilfoot : getItemUrl('lfoot')}
      />
    </div>
  );
}
