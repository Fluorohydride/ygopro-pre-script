--魔道騎竜カース・オブ・ドラゴン
--
--Script by mercury233
--not fully implemented
function c100277001.initial_effect(c)
	aux.AddCodeList(c,66889139)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),c100277001.matfilter2,true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100277001,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100277001)
	e1:SetCondition(c100277001.thcon)
	e1:SetTarget(c100277001.thtg)
	e1:SetOperation(c100277001.thop)
	c:RegisterEffect(e1)
	--grave fusion material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetTarget(c100277001.mttg)
	e2:SetValue(c100277001.mtval)
	c:RegisterEffect(e2)
	--
	if not aux.fus_mat_hack_check then
		aux.fus_mat_hack_check=true
		function aux.fus_mat_hack_exmat_filter(c)
			return c:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL,c:GetControler())
		end
		_GetFusionMaterial=Duel.GetFusionMaterial
		function Duel.GetFusionMaterial(tp)
			local g=_GetFusionMaterial(tp)
			local exg=Duel.GetMatchingGroup(aux.fus_mat_hack_exmat_filter,tp,LOCATION_GRAVE,0,nil)
			return g+exg
		end
		_SendtoGrave=Duel.SendtoGrave
		function Duel.SendtoGrave(tg,reason)
			if reason~=REASON_EFFECT+REASON_MATERIAL+REASON_FUSION or Auxiliary.GetValueType(tg)~="Group" then
				return _SendtoGrave(tg,reason)
			end
			local rg=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			tg:Sub(rg)
			local tc=rg:Filter(aux.fus_mat_hack_exmat_filter,nil):GetFirst()
			if tc then
				local te=tc:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL,tc:GetControler())
				te:UseCountLimit(tc:GetControler())
			end
			local ct1=_SendtoGrave(tg,reason)
			local ct2=Duel.Remove(rg,POS_FACEUP,reason)
			return ct1+ct2
		end
	end
end
function c100277001.matfilter2(c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_DRAGON)
end
function c100277001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c100277001.thfilter(c)
	return aux.IsCodeListed(c,66889139) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100277001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100277001.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100277001.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100277001.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100277001.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c100277001.mttg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100277001.mtval(e,c)
	if not c then return false end
	return c:IsLevel(7) and c:IsRace(RACE_DRAGON)
end
