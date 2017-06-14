--影六武衆－ハツメ
--Shadow Six Samurai – Hatsume
function c100419003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100419003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,100419003)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100419003.cost)
	e1:SetTarget(c100419003.target)
	e1:SetOperation(c100419003.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c100419003.reptg)
	e2:SetValue(c100419003.repval)
	e2:SetOperation(c100419003.repop)
	c:RegisterEffect(e2)
end
function c100419003.filter1(c)
	return c:IsSetCard(0x3d) and c:IsAbleToRemoveAsCost() and ((c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()) or c:IsLocation(LOCATION_GRAVE))
end
function c100419003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local sg=Duel.GetMatchingGroup(c92572371.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	if chk==0 then return sg:GetCount()>=2
		and (ft>0 or (ct<3 and sg:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE))) end
	local g=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<2 then
			sg:Sub(g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=sg:Select(tp,2-ct,2-ct,nil)
			g:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=sg:Select(tp,2,2,nil)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100419003.filter2(c,e,sp)
	return c:IsSetCard(0x3d) and c:GetCode()~=100419003 and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c100419003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100419003.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c100419003.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100419003.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100419003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100419003.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3d) 
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c100419003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100419003.repfilter,1,nil,tp)
	and eg:GetCount()==1
	end
	return Duel.SelectYesNo(tp,aux.Stringid(100419003,1))
end
function c100419003.repval(e,c)
	return c100419003.repfilter(c,e:GetHandlerPlayer())
end
function c100419003.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
