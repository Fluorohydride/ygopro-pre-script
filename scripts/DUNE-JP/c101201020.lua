--破械神シュヤーマ
--Script by 奥克斯
function c101201020.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(101201020,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101201020)
	e1:SetTarget(c101201020.destg)
	e1:SetOperation(c101201020.desop)
	c:RegisterEffect(e1)  
	--special summon 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101201020+100)
	e2:SetTarget(c101201020.spdtg)
	e2:SetOperation(c101201020.spdop)
	c:RegisterEffect(e2)  
end
function c101201020.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101201020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc,TYPE_SPELL+TYPE_TRAP)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101201020,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			if #dg==0 then return false end
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
--
function c101201020.desfilter(c,tp)
	if Duel.GetMZoneCount(tp,c)==0 then return false end
	if c:IsFaceup() then 
		return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_FIEND)
	else return true end
end
function c101201020.spdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c101201020.desfilter(chkc,tp) end
	if chk==0 then return ec:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c101201020.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101201020.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ec,1,0,0)
end
function c101201020.spdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1,true)
	end   
end