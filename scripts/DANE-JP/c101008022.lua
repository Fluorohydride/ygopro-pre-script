--擾乱騒蛇ラウドクラウド 
--
--Scripted By-fwkongge
function c101008022.initial_effect(c)
	--
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101008022,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101008022.spcon)
	e1:SetOperation(c101008022.spop)
	c:RegisterEffect(e1)
	--destroy monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101008022,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,101008022)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101008022.descost)
	e2:SetTarget(c101008022.destg)
	e2:SetOperation(c101008022.desop)
	c:RegisterEffect(e2)
	--destroy spell/trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101008022,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,101008022+1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c101008022.descost1)
	e3:SetTarget(c101008022.destg1)
	e3:SetOperation(c101008022.desop1)
	c:RegisterEffect(e3)
end
function c101008022.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
end
function c101008022.spcost_selector(c,tp,g,sg,i)
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<2 then
		flag=g:IsExists(c101008022.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_FIRE)>0
			and sg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WIND)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c101008022.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(c101008022.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	return g:IsExists(c101008022.spcost_selector,1,nil,tp,g,sg,1)
end
function c101008022.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c101008022.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c101008022.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c101008022.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost()
end
function c101008022.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008022.desfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101008022.desfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101008022.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101008022.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetTextAttack()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function c101008022.desfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToRemoveAsCost()
end
function c101008022.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008022.desfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101008022.desfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101008022.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101008022.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101008022.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c101008022.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101008022.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101008022.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
